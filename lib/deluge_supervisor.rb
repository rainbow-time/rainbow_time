require 'deluge'
require_relative 'torrent_categorizer.rb'

class DelugeSupervisor
  attr_reader :client
  attr_reader :core

  def initialize(settings)
    @settings = settings

    @client = Deluge::Api::Client.new(
        host: settings['deluge_host'], port: settings['deluge_port'],
        login: settings['deluge_user'], password: settings['deluge_pass']
    )
    @client.connect
    @core = client.core

    @managed_label = settings['deluge_label']

    puts ":::: logged in to deluge! ::::"
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
    core.enable_plugin('Label')
    unless client.label.get_labels.include?(@managed_label)
      client.label.add(@managed_label)
    end
  end
end