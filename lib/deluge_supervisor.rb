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

# a39ec0316df1037e00fb0b8c2e7e6d669b963d2f    ---    Rango (2009) [1080p]
# [{"index"=>0,
#   "size"=>1613954473,
#   "offset"=>0,
#   "path"=>"Rango (2009) [1080p]/Rango.2009.1080p.BrRip.x264.YIFY.mp4"},
#  {"index"=>1,
#   "size"=>100160,
#   "offset"=>1613954473,
#   "path"=>"Rango (2009) [1080p]/Rango.2009.1080p.BrRip.x264.YIFY.srt"},
#  {"index"=>2,
#   "size"=>130677,
#   "offset"=>1614054633,
#   "path"=>"Rango (2009) [1080p]/WWW.YIFY-TORRENTS.COM.jpg"}]

  def test_rename_and_move
    tid = 'a39ec0316df1037e00fb0b8c2e7e6d669b963d2f'
    puts "looking up torrent..."
    client.core.set_torrent_move_completed(tid, false) # tested
    torrent = client.core.get_torrent_status(tid, ["name", "files", "save_path", "move_completed_path", "move_completed"])
    puts tid + "    ---    " + torrent["name"]
    pp torrent['files']
    puts "++"
    pp torrent['save_path']
    pp torrent['move_completed_path']
    puts "move completed: #{torrent['move_completed']}"
    puts "--------"
    client.core.move_storage([tid], @settings['categorized_dir']) # D:\Categorized
    client.core.rename_files(tid, [[0,'test-folder2/anotherfolder/rango-test.mp4']])
    puts "DID rename test!"
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