class RainbowTime::TraktApiWrapper
  attr_reader :client, :config

  def initialize(client, config)
    @client = client
    @config = config
    @with_auth = {username: config.auth.username, auth: true}
  end

  # don't let trakt_api change data in this hash
  def with_auth
    @with_auth.clone
  end
end


class RainbowTime::TraktState < RainbowTime::TraktApiWrapper
  attr_reader :state, :lists, :control_lists_with_items

  def initialize(client, config)
    super(client, config)
    @state = mash
    @lists = nil
    @control_lists_with_items = mash
  end

  def control_lists_names
    config.lists.values
  end

  def missing_control_lists?
    pp lists; exit
    all_lists_names = lists.map(&:name)
    (control_lists_names & all_lists_names) != control_lists_names # set intersection
  end

  def create_control_lists
    # bruteforce
    debug "create control lists: #{control_lists_names}"
    control_lists_names.each do |name|
      debug "add control list `#{name}`"
      client.lists.add(name: name, privacy: 'private', **with_auth)
    end
  end

  def load_lists
    debug 'loading lists'
    @lists = mash(client.user.lists(**with_auth))
  end

  def load_or_create_lists
    load_lists

    if missing_control_lists?
      create_control_lists
      load_lists
    end
  end

  def load_list_items
    config.lists.each do |key, name|
      list = lists.find{|l| l.name == name}
      # load full data
      debug "loading items for `#{name}` control list"
      # CONCURRENT
      control_lists_with_items[key] = client.user.list(slug: list.slug, **with_auth)
    end
  end

  def sync!
    load_or_create_lists
    load_list_items
    state.last_updated = Time.now
  end
end


class RainbowTime::TraktData < RainbowTime::TraktApiWrapper
  # get tv shows and cache them in memory
  # get movie info
end
