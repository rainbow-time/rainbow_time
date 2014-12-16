# class RainbowTime::MediaItem < Sequel::Model(:media_items)
class RainbowTime::MediaItem < Sequel::Model
  plugin :single_table_inheritance, :type,
          model_map: {0 => "RainbowTime::Movie", 1 => "RainbowTime::Show"}

  one_to_many :orders
  one_to_many :torrents
end