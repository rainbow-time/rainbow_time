class RainbowTime::Torrent < Sequel::Model
  many_to_many :orders

  # torrent has one media through order, but some torrents need to be categorized without orders
  many_to_one :media_item
  one_to_many :torrent_media_files


  def order
    orders.first
  end

  def load_deluge_info
    # @deluge_torrent = Deluge::API...infohahs...
  end
end