require_relative 'spec_helper.rb'

# "http://trakt.tv/show/the-great-british-bake-off/season/5/episode/2"
# s1 = RainbowTime::Show.new(title: "The Great British Bake Off",
#   year: 2010, network: "BBC One",
#   trakt_show_url: "http://trakt.tv/show/the-great-british-bake-off")


# s2 = RainbowTime::Show.new(title: "The Great British Bake Off",
#   year: 2010, network: "BBC One",
#   season: 2,
#   trakt_show_url: "http://trakt.tv/show/the-great-british-bake-off")

# s3 = RainbowTime::Show.new(title: "The Great British Bake Off",
#   year: 2010, network: "BBC One",
#   season: 2, episode: s2,
#   trakt_show_url: "http://trakt.tv/show/the-great-british-bake-off")

# puts s1.object_store_file_name
# puts s2.object_store_file_name
# puts s3.object_store_file_name


# pp s1.to_hash
# pp s2.to_hash
# pp s3.to_hash

describe 'Store' do
  it 'stores and loads to YAML' do
    class RainbowTime::Show
      property :sideshow
    end

    show = RainbowTime::Show.new(title: "The Great British Bake Off",
      year: 2010, network: "BBC One",
      season: 2, episode: 9,
      trakt_show_url: "http://trakt.tv/show/the-great-british-bake-off")

    sideshow = RainbowTime::Show.new(title: "Sideshow",
      year: 1999, network: "BBC Two",
      season: 88, episode: 99,
      trakt_show_url: "http://trakt.tv/show/sideshow")

    show.sideshow = sideshow

    stored = YAML.dump(show)
    recovered = YAML.load(stored)

    expect(recovered).to eq show
    expect(recovered.sideshow).to eq sideshow
  end
end
