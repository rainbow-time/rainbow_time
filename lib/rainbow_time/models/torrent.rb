class RainbowTime::Torrent < Sequel::Model
  many_to_many :orders

  # torrent has one media through order, but some torrents need to be categorized without orders
  many_to_one :media_item
  one_to_many :torrent_media_files

  def before_destroy
    torrent_media_files.each do |tf|
      tf.destroy
    end
  end

  def before_save
    unless media_item_id
      self.media_item = orders.first.media_item if orders.first
    end
  end

  def load_deluge_info
    # @deluge_torrent = Deluge::API...infohash...
  end
end