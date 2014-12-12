class RainbowTime::TorrentMediaFile < Sequel::Model
  many_to_one :torrent
end