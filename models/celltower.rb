class CellTower
  def initialize(aio, data_item_name, data_item_index)
    @aio = aio
    @snr = 0
    @rsrp = 0
    @rsrq = 0
    @cell_id = 0
    @data_item_name = data_item_name
    @data_item_index = data_item_index
    @tower_type = data_item_name.include?("LTE") ? "LTE" : "5G"
    get_groups()

  end

  def get_groups()
    @default_group = @aio.group(key: "default")
    @group = @aio.group(key: @tower_type.downcase) rescue nil
    if @group.nil?
      puts "creating group #{@tower_type}"
      @group = @aio.create_group(name: @tower_type.downcase)
    end

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
end
