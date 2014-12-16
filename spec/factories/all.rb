FactoryGirl.define do
  # make FG work with Sequel
  to_create { |instance| instance.save }

  factory :movie, :class => RainbowTime::Movie do
    sequence(:slug) {|n| "my-movie_#{n}"}
    sequence(:title) {|n| "My Movie: #{n}"}
    sequence(:year) {|n| 1988 + n}
    trakt_url { "http://trakt.tv/movie/#{slug}-#{year}" }
    sequence(:imdb_id) {|n| "123imdb#{n}"}
  end

  factory :show, :class => RainbowTime::Show do
    sequence(:slug) {|n| "my-show#{n}"}
    sequence(:title) {|n| "My Show: #{n}"}
    sequence(:year) {|n| 1978 + n}
    trakt_url { "http://trakt.tv/show/#{slug}" }
    sequence(:tvdb_id) {|n| "999tvdb_id#{n}"}
  end

  factory :order, :class => RainbowTime::Order do
    association :media_item, factory: :movie
    type 0
    state :new
    trakt_state :new
    trakt_state_synced true

    factory :season_order do
      association :media_item, factory: :show
      season 5
      factory :episode_order do
        episode 7
      end
    end
  end

  factory :torrent, :class => RainbowTime::Torrent do
    sequence(:infohash) {|n| "deadbeef#{n}"}
    sequence(:name) {|n| "my show or movie #{n} [133t krew]"}
  end

  factory :torrent_media_file, :class => RainbowTime::TorrentMediaFile do
    sequence(:filename) {|n| "/media/video_file_#{n}.avi"}
    sequence(:subtitle_filename) {|n| "/media/video_subtitle_#{n}.srt"}
  end
end
