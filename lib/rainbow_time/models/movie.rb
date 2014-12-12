class RainbowTime::Movie < RainbowTime::MediaItem
  def validate
    super
    validates_presence :imdb_id
  end
end