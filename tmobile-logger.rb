require 'adafruit/io'
require 'faraday'
require_relative 'models/celltower'

#Read JSON from a file, iterate over objects
file = open("settings.json")
json_file = file.read

settings = JSON.parse(json_file)

key = settings["key"]
username = settings["username"]

# create an instance
aio = Adafruit::IO::Client.new key: key, username: username

first_tower = CellTower.new(aio, "cell_LTE_stats_cfg", 0)
second_tower = CellTower.new(aio, "cell_5G_stats_cfg", 0)

tmobile_stats = Faraday.get 'http://192.168.12.1/fastmile_radio_status_web_app.cgi'

if (tmobile_stats.status != 200)
  puts "T-Mobile device didn't respond as expected."
  exit
end

tmobile_json = JSON.parse(tmobile_stats.body)

first_tower.update_from_data(tmobile_json)
second_tower.update_from_data(tmobile_json)

puts first_tower
puts second_tower
