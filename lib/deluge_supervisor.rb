require 'deluge'
require_relative 'torrent_categorizer.rb'

class DelugeSupervisor
  attr_reader :settings
  attr_reader :client, :core

  def initialize(settings)
    @settings = settings
    @managed_label = settings['deluge_label']

    establish_connection
  end

  def establish_connection
    @client = Deluge::Rpc::Client.new(
        host: settings['deluge_host'], port: settings['deluge_port'],
        login: settings['deluge_user'], password: settings['deluge_pass']
    )
    @client.connect
    @core = client.core

    info "Connected to deluged #{@client.daemon.info}! Auth level = #{@client.auth_level}"
  end


  def process_torrents
    configure_labels_plugin

    torrent_ids = core.get_session_state
    # DEBUG
    # torrent_ids = 
    torrent_ids.each do |tid|
      t = core.get_torrent_status(tid, ["name", "label"])
      if t['label'].include?(@managed_label)
        debug "skipping already processed torrent '#{t['name']}'"
        next
      end

      name = t['name']
      begin
        t = core.get_torrent_status(tid, ["name", "files", "hash"])
      rescue Exception => e
        error "Failed to read torrent files '#{name}' #{tid}: #{e.message}"
        @client.connect
        next
      end
      process_torrent(t)
    end
  end

  def process_torrent(t)
    name = t['name']
    debug "processing torrent '#{name}'  [#{t['hash']}]"
    categorizer = TorrentCategorizer.new(t['hash'], name, t['files'])

    unless categorizer.is_categorizable_video?
      debug "skipping because it's a non-video torrent"
      return
    end

    if categorizer.is_tv?
      process_tv_torrent(t)
    else categorizer.is_movie?
      process_movie_torrent(t)
    end

    info "processed! adding label: '#{@managed_label}'"
    # client.label.set_torrent(tid, @managed_label)
  end


  def process_tv_torrent(t)
    debug "processing TV"
  end


  def process_movie_torrent(t)
    debug "processing movie"
  end

  def configure_labels_plugin
    enabled_plugins = core.get_enabled_plugins || [] # returns nil if array is empty
    unless enabled_plugins.include?('Label')
      info "Enabling plugin 'Label' and reconnecting to Deluge"
      core.enable_plugin('Label')
      establish_connection # reload RPC methods
    end

    unless client.label.get_labels.include?(@managed_label)
      client.label.add(@managed_label)
    end
  end
end