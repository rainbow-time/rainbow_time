class RainbowTime::Show < RainbowTime::MediaItem
  # tvrage_id
  def validate
    super
    validates_presence :tvdb_id
  end
end
