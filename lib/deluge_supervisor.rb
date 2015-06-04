require 'deluge'

class DelugeSupervisor
  attr_reader :client

  def initialize(settings)
    @settings = settings

    @client = Deluge::Api::Client.new(
        host: 'localhost', port: 58846,
        login: settings['deluge_user'], password: settings['deluge_pass']
    )
    @client.connect

    puts ":::: logged in to deluge! ::::"
  end

  def sayhi
    puts "hiiiiiiiiii"
  end

  def list_torrent_contents
    torrent_ids =  client.core.get_session_state
    torrent_ids.each do |tid|
      torrent = client.core.get_torrent_status(tid, ["name", "files"])
      puts tid + "    ---    " + torrent["name"]
      pp torrent['files']
      puts "--------"
    end
  end
end