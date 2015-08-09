module TorrentInfoSource
end

dirname = File.basename(__FILE__)
info_sources = Dir.glob("#{dirname}/torrent_info_source/*.rb")
info_sources.each do |path|
  require path
end

