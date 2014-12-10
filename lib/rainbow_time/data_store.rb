class RainbowTime::DataStore
  @config = nil

  def self.config=(val)
    @config = val
  end

  def self.config
    raise "forgot to set config" if @config.nil?
    @config
  end

  def base_dir
    config.data_store_dir
  end

  def self.load_all
  end

  def self.store_object(obj)
  end
end


class RainbowTime::StoredObject
  def obect_store_base_dir
    type_dir = self.class.to_s.underscore.dasherize
    File.join(DataStore.base_dir, type_dir)
  end
end


class RainbowTime::Torrent < RainbowTime::StoredObject
end

class RainbowTime::Movie < RainbowTime::StoredObject
end


class RainbowTime::Show < RainbowTime::StoredObject
end