require 'adafruit/io'
require 'faraday'

#Read JSON from a file, iterate over objects
file = open("settings.json")
json_file = file.read

settings = JSON.parse(json_file)

key = settings["key"]
username = settings["username"]

# create an instance
aio = Adafruit::IO::Client.new key: key, username: username

tmobile_stats = Faraday.get 'http://192.168.12.1/fastmile_radio_status_web_app.cgi'

puts tmobile_stats.body
