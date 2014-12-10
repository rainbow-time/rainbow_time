P_DO_NOT_DOWNLOAD = 0
P_NORMAL = 1
P_HIGH = 5
P_HIGHEST = 7



d = Deluge.new '127.0.0.1', '58846'

d.login 'abc', 'abc'
puts ":::: logged in ::::"

# exit
# puts d.get_torrent_status("ab9f330e5f58fe8840907c912a7fa2e2234d50c9", {})
# exit
#get_torrents_status(filter_dict, keys, diff=False)
# puts d.call "web.get_torrent_files", "ab9f330e5f58fe8840907c912a7fa2e2234d50c9", {}, false
# puts d.call "core.get_torrents_status", "", {}, false
# exit

def list_torrent_contents(d)
  torrent_ids =  d.get_session_state
  torrent_ids.each do |tid|
    torrent = d.get_torrent_status(tid, ["name", "files"])
    puts tid + "    ---    " + torrent["name"]
    pp torrent['files']
    puts "--------"
  end
end




d.set_torrent_file_priorities("dd5c710cd265945baf5cf7b945d7e661ddd2a013", [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, P_HIGH, P_HIGH, 0, 0, 0, 0, P_HIGH, P_HIGH, 0, 0], )
pp d.get_torrent_status("dd5c710cd265945baf5cf7b945d7e661ddd2a013", [])


# need torrent current download state, current P

# set_P(d, 56, P_HIGH)
puts ":::: done ::::"
