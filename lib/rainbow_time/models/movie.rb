class RainbowTime::Movie < RainbowTime::MediaItem
  # tmdb_id
  def validate
    super
    validates_presence :imdb_id
  end
end