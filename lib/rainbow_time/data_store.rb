class RainbowTime::DataStore
  def self.base_dir
    RainbowTime.config.data_store_dir
  end

  def self.load_all
  end

  def self.store_object(obj)
  end
end


class RainbowTime::StoredObject
  def self.obect_store_base_dir
    type_dir = self.to_s.demodulize.underscore.dasherize
    File.join(RainbowTime::DataStore.base_dir, type_dir)
  end

  def obect_store_base_dir
    type_dir = self.class.obect_store_base_dir
  end


  def object_store_file_name
    raise "child class must implement this method"
  end

  def object_store_file_extension
    ".json"
  end

  def save
    RainbowTime::DataStore.store_object(self)
  end
end


class RainbowTime::Torrent < RainbowTime::StoredObject
  attr_accessor :infohash, :name

  def initialize(infohash:, name:nil)
    @infohash = infohash
    @name = name
  end

  def object_store_file_name
    file = @infohash.clone
    unless @name.to_s.empty?
      file << "--"
      file << @name.to_s.clean_dashes
    end
    file << object_store_file_extension
  end
end

class RainbowTime::Movie < RainbowTime::StoredObject
  attr_accessor :title, :year, :trakt_movie_url, :trakt_movie_slug_id

  def initialize(title:, year:, trakt_movie_url:)
    @title = title
    @year = year
    @trakt_movie_url = trakt_movie_url

    # "http://trakt.tv//movie/batman-1989" -> "batman-1989"
    @trakt_movie_slug_id = RainbowTime::TraktApiWrapper.url_to_slug(trakt_movie_url)

  end

  def object_store_file_name
    trakt_movie_slug_id + object_store_file_extension
  end

  def type
    :movie
  end
end


class RainbowTime::Show < RainbowTime::StoredObject
  attr_accessor :title, :year, :network, :trakt_show_url, :season, :episode, :trakt_show_slug_id

  def initialize(title:, year:, network:, season:nil, episode:nil, trakt_show_url:)
    @title = title
    @year = year
    @network = network
    @season = season
    @episode = episode
    @trakt_show_url = trakt_show_url

    # "http://trakt.tv/show/the-great-british-bake-off/season/5/episode/2" => "the-great-british-bake-off"
    @trakt_show_slug_id = RainbowTime::TraktApiWrapper.url_to_slug(trakt_show_url)
  end

  def type
    if(season && episode)
      :episode
    elsif(season)
      :season
    else
      :show
    end
  end

  def object_store_file_name
    file = trakt_show_slug_id.clone
    file << "-" + network.to_s.clean_dashes if network
    file << "-season-#{season}" if(season)
    file << "-episode-#{episode}" if(episode)

    file << object_store_file_extension
  end
end