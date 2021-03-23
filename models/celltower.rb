require 'pry'

class CellTower
  def initialize(aio, data_item_name, data_item_index)
    @aio = aio
    @snr = 0
    @rsrp = 0
    @rsrq = 0
    @cell_id = 0
    @data_item_name = data_item_name
    @data_item_index = data_item_index
    @tower_type = data_item_name.include?("LTE") ? "lte" : "5g"
    get_groups()
    get_feeds()
  end

  def get_groups()
    @default_group = @aio.group(key: "default")
    @group = @aio.group(key: @tower_type.downcase) rescue nil
    if @group.nil?
      puts "Creating group #{@tower_type}"
      @group = @aio.create_group(name: @tower_type.downcase)
    end
    
  end

  def get_feeds()
    @snr_feed = get_feed "snr"
    @rsrp_feed = get_feed "rsrp"
    @rsrq_feed = get_feed "rsrq"
    @cell_id_feed = get_feed "cell-id"
  end

  def get_feed(feed_name)
    feed_key = "#{@group['key']}.#{feed_name}"
    feed = @aio.feed_details("#{feed_key}") rescue nil
    if feed.nil?
      puts "Creating #{feed_key}"
      feed = @aio.create_feed(name: feed_name, group: @group)
      @aio.group_add_feed(@group, feed)
      @aio.group_remove_feed(@default_group, feed)
    end
    feed
  end
  
  attr_accessor :snr
  attr_accessor :rsrp
  attr_accessor :rsrq
  attr_accessor :cell_id

  def update_from_data(data)
    @snr = data[@data_item_name][@data_item_index]["stat"]["SNRCurrent"]
    @rsrp = data[@data_item_name][@data_item_index]["stat"]["RSRPCurrent"]
    @rsrq = data[@data_item_name][@data_item_index]["stat"]["RSRQCurrent"]
    @cell_id = data[@data_item_name][@data_item_index]["stat"]["PhysicalCellID"]
  end

  def update_adafruit_from_data()

  end

  def to_s
    "SNR - #{@snr}, RSRP = #{@rsrp}, RSRQ = #{@rsrq}, cell id = #{@cell_id}"
  end
end
