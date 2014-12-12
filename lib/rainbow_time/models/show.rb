class RainbowTime::Show < RainbowTime::MediaItem
  plugin :serialization, :show_specification_yaml, :show_specification
  plugin :serialization_modification_detection

  def validate
    validates_presence :tvdb_id
  end
end
