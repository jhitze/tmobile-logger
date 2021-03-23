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

if (tmobile_stats.status != 200)
  puts "T-Mobile device didn't respond as expected."
  exit
end

tmobile_json = JSON.parse(tmobile_stats.body)
puts "5g - #{tmobile_json["cell_5G_stats_cfg"]}"
puts "4g - #{tmobile_json["cell_LTE_stats_cfg"]}"

class SignalData 
  @snr = 0
  @rsrp = 0
  @rsrq = 0
  @cell_id = 0
  attr_accessor :snr
  attr_accessor :rsrp
  attr_accessor :rsrq
  attr_accessor :cell_id
end

signals = []

fiveg_signal = SignalData.new
fiveg_signal.snr = tmobile_json["cell_5G_stats_cfg"][0]["stat"]["SNRCurrent"]
fiveg_signal.rsrp = tmobile_json["cell_5G_stats_cfg"][0]["stat"]["RSRPCurrent"]
fiveg_signal.rsrq = tmobile_json["cell_5G_stats_cfg"][0]["stat"]["RSRQCurrent"]
fiveg_signal.cell_id = tmobile_json["cell_5G_stats_cfg"][0]["stat"]["PhysicalCellID"]

puts fiveg_signal.inspect


#fourg_group = aio.group(key: "4G")
#puts fourg_group.inspect
fourg_group = aio.group(key: "4g")
puts fourg_group.inspect
fiveg_group = aio.group(key: "5g")
puts fiveg_group.inspect
puts "-" * 80

def add_feeds(aio, group)
  default_group = aio.group(key: "default")
  add_feed_to_group(aio, default_group, group, "snr"
  
  rsrp_feed = aio.create_feed(name: "rsrp")
  aio.group_add_feed(group, rsrp_feed)
  aio.group_remove_feed(default_group, rsrp_feed)
  rsrq_feed = aio.create_feed(name: "rsrq")
  aio.group_add_feed(group, rsrq_feed)
  aio.group_remove_feed(default_group, rsrq_feed)
end

def add_feed_to_group(aio, default_group, group, feed_name)
  feed_key = "#{group.key}.#{feed_name}"
  feed = aio.feed_details("#{feed_key}") rescue nil
  if feed.nil?
    puts "Creating #{feed_key}"
    feed = aio.create_feed(name: feed_name, group: group)
    aio.group_add_feed(group, feed)
    aio.group_remove_feed(default_group, feed)
  end
end


add_feeds(aio, fourg_group)
add_feeds(aio, fiveg_group)
#feed_name = "T-Mobile_#{fiveg_signal.cell_id}"
#fed = aio.create_feed(name: feed_name)
#aio.send_data feed, 

