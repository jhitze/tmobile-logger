require 'adafruit/io'
require 'json'

#Read JSON from a file, iterate over objects
file = open("settings.json")
json_file = file.read

settings = JSON.parse(json_file)

key = settings["key"]
username = settings["username"]

# create an instance
aio = Adafruit::IO::Client.new key: key, username: username
