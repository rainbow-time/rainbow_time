require_relative '../rainbow.rb'

"http://trakt.tv/show/the-great-british-bake-off/season/5/episode/2"
s1 = RainbowTime::Show.new(title: "The Great British Bake Off",
  year: 2010, network: "BBC One",
  trakt_show_url: "http://trakt.tv/show/the-great-british-bake-off")


s2 = RainbowTime::Show.new(title: "The Great British Bake Off",
  year: 2010, network: "BBC One",
  season: 2,
  trakt_show_url: "http://trakt.tv/show/the-great-british-bake-off")

s3 = RainbowTime::Show.new(title: "The Great British Bake Off",
  year: 2010, network: "BBC One",
  season: 2, episode: 20,
  trakt_show_url: "http://trakt.tv/show/the-great-british-bake-off")

# puts s1.object_store_file_name
# puts s2.object_store_file_name
# puts s3.object_store_file_name

dump = YAML.dump(s3)
# puts dump

recovered = YAML.load(dump)

pp recovered.object_store_file_name
pp recovered