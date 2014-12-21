class RainbowTime::TraktOrderItem
  extend Memoist

  attr_reader :item

  def initialize(item)
    @item = item
  end

  def type
    @item.type
  end

  def media_type
    (item_type == "movie") ? "movie" : "show"
  end

  def movie?
    media_type == "movie"
  end

  def show?
    media_type == "show"
  end

  def media_data
    @item[media_type]
  end
  memoize :media_data

  def url
    media_data.url
  end

  def slug
    self.class.url_to_slug(url)
  end
  memoize :slug

  def season
    media_data.season
  end

  def episode_num
    media_data.episode_num
  end

  def episode
    media_data.episode
  end

  def find_media_item
    RainbowTime::MediaItem.where(:slug => slug).first
  end

  def find_order
    media_item = find_media_item
    return nil unless media_item

    if movie?
      return media_item.orders.first
    end

    media_item.orders.where(season: season, episode: episode_num).first
  end

  # returns movie or show slug (works with show/movie urls not with episode/season urls)
  def self.url_to_slug(trakt_url)
    URI(trakt_url).path.split('/').reject(&:empty?)[1]
  end

end