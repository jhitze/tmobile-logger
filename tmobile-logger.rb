require 'adafruit/io'
reqyire 'json'

#Read JSON from a file, iterate over objects
file = open("settings.json")
json_file = file.read

settings = JSON.parse(json_file)

# create an instance
aio = Adafruit::IO::Client.new key: settings["key"], username["username"]
