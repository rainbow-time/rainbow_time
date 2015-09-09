require_relative 'deluge_connection'
require_relative 'torrent'
require 'httpclient'

class RainbowTime::MainLoop
  attr_reader :deluge, :http, :torrents

  def initialize
    @deluge = DelugeConnection.new
    @deluge.connect
    @deluge.configure_labels_plugin

    @http = HTTPClient.new
  end

  def run
    # REPEAT AS A LOOP!
    # id = 'dd5c710cd265945baf5cf7b945d7e661ddd2a013'
    # load_torrents
    # process_torrents
    pp deluge.core.get_config
  end

  require 'benchmark'
  def test_benchmark
    id = 'dd5c710cd265945baf5cf7b945d7e661ddd2a013'
    pp deluge.core.get_torrent_status(id, %w(files file_priorities))
    # puts Benchmark.measure {
    #   threads = []
    #   10.times do
    #     threads << Thread.new do
    #       1000.times { deluge.core.get_torrent_status(id, %w(name label files file_progress)) }
    #     end
    #   end
    #   threads.each {|t| t.join}
    # }
  end

  def load_torrents
    hash_ids = deluge.core.get_session_state
    @torrents = hash_ids.map {|hid| RainbowTime::Torrent.new(deluge, http, hid)}
  end

  def process_torrents
    @torrents.each {|t| t.process}
  end

  def process_torrent(t)
    name = t['name']
    info "processing torrent '#{name}'  [#{t['hash']}]"
    categorizer = TorrentCategorizer.new(t['hash'], name, t['files'])
    categorizer.process!

    case categorizer.category
    when :non_video
      debug "skipping because it's a non-video torrent"
      return
    when :tv
      process_tv_torrent(t)
    when :movie
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
end