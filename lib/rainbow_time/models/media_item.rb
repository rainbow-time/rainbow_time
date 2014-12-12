# class RainbowTime::MediaItem < Sequel::Model(:media_items)
class RainbowTime::MediaItem < Sequel::Model
  plugin :single_table_inheritance, :type,
          model_map: {1 => "RainbowTime::Movie", 2 => "RainbowTime::Show"}

    # title
    # year
    # trakt_url
    # imdb_id (can be blank)
  def validate
    super
    # validates_min_length 1, :num_tracks
  end
end