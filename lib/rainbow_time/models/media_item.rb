# class RainbowTime::MediaItem < Sequel::Model(:media_items)
class RainbowTime::MediaItem < Sequel::Model
  plugin :single_table_inheritance, :type,
          model_map: {1 => "RainbowTime::Movie", 2 => "RainbowTime::Show"}

  one_to_many :orders
end