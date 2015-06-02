class RainbowTime::TraktApi
  attr_reader :api_key, :username, :password, :base_url
  def initialize(api_key, username, password)
    @api_key = api_key
    @username = username
    @password = password

    @base_url = 'http://api.trakt.tv'
  end

  def get(resource)
    handle_response Typhoeus::Request.get("#{base_url}/#{resource}", userpwd: "#{username}:#{password}")
  end

  def post(resource, body)
    handle_response Typhoeus::Request.post("#{base_url}/#{resource}", userpwd: "#{username}:#{password}", body: body)
  end

  def handle_response(response)
    if response.success?
      return JSON.parse(response.body)
    end

    request_info = response.request.options[:method].to_s.upcase + " " + response.effective_url
    if response.timed_out?
      raise RainbowTime::TraktApiError.new("#{request_info} got a time out")
    elsif response.code == 0
      # Could not get an http response, something's wrong.
      raise RainbowTime::TraktApiError.new(request_info + " " + response.return_message)
    else
      # Received a non-successful http response.
      debug response
      debug response.body
      raise RainbowTime::TraktApiError.new("#{request_info} HTTP request failed: " + response.code.to_s)
    end
  end

  def user_lists
    # GET http://api.trakt.tv/user/lists.json/77f158b7a2087efab2542ecbfe9711f4/justin
    get("user/lists.json/#{api_key}/#{username}")
  end

  def create_private_list(name)
    # POST
    # see http://trakt.tv/api-docs/lists-add
  end

  def list_items(slug)
  end

  # http://trakt.tv/api-docs/lists-items-add
  def list_add_items(list_slug, items)
    # POST
  end

  # http://trakt.tv/api-docs/lists-items-delete
  def list_delete_items(list_slug, items)
    # POST
  end

  def movie_summary(slug_or_imdbid)
    # http://api.trakt.tv/movie/summary.json/77f158b7a2087efab2542ecbfe9711f4/batman-1989
  end

  def show_seasons(slug_or_tvdbid)
    # http://api.trakt.tv/show/seasons.json/77f158b7a2087efab2542ecbfe9711f4/the-walking-dead
  end

  def show_season_episodes(slug_or_tvdbid, season)
    # http://api.trakt.tv/show/season.json/77f158b7a2087efab2542ecbfe9711f4/the-walking-dead/1
  end

  def movie_search(query)
    # GET http://api.trakt.tv/search/movies.json/77f158b7a2087efab2542ecbfe9711f4?query=batman
  end

  def show_search(query)
    # GET http://api.trakt.tv/search/shows.json/77f158b7a2087efab2542ecbfe9711f4?query=big+bang+theory
  end

end