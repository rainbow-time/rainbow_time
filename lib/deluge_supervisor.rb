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
    torrent_ids.each do |tid|
      t = core.get_torrent_status(tid, ["name", "label"])
      next if t['label'].include?(@managed_label)

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
    info "processing torrent '#{name}'"
    categorizer = TorrentCategorizer.new(name, t['files'])

    unless categorizer.is_categorizable_video?
      info "skipping non-video torrent '#{name}'"
      return
    end

    if categorizer.is_tv?
      process_tv_torrent(t)
    elsif categorizer.is_movie?
      process_movie_torrent(t)
    else
      info "skipping unknown type torrent '#{name}'"
      return
    end

    info "adding label '#{@managed_label}' to '#{name}'"
    # client.label.set_torrent(tid, @managed_label)
  end


  def process_tv_torrent(t)
  end


  def process_movie_torrent(t)
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