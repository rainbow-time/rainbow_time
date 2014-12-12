class RainbowTime::Torrent < Sequel::Model
  many_to_many :orders
  one_to_many :torrent_media_files

  def order
    orders.first
  end
end