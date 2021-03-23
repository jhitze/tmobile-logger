require 'adafruit/io'
require 'faraday'

#Read JSON from a file, iterate over objects
file = open("settings.json")
json_file = file.read

settings = JSON.parse(json_file)

key = settings["key"]
username = settings["username"]

# create an instance
#aio = Adafruit::IO::Client.new key: key, username: username

tmobile_stats = Faraday.get 'http://192.168.12.1/fastmile_radio_status_web_app.cgi'

if (tmobile_stats.status != 200)
  puts "T-Mobile device didn't respond as expected."
  exit
end

tmobile_json = JSON.parse(tmobile_stats.body)
puts "5g - #{tmobile_json["cell_5G_stats_cfg"]}"
puts "4g - #{tmobile_json["cell_LTE_stats_cfg"]}"

