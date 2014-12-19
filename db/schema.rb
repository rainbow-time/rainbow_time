# http://sequel.jeremyevans.net/rdoc/files/doc/schema_modification_rdoc.html
# rm db/rainbow.db; sequel sqlite://db/rainbow.db db/schema.rb -E
DB.create_table(:media_items) do
  primary_key :id

  String  :slug, null: false
  index :slug, unique: true

  Integer :type, default: 1, null: false # 1 = movie, 2 = show

  String  :title, null: false
  Integer :year, null: false
  String  :trakt_url, null: false

  String  :imdb_id, default: ""
  String  :tmdb_id, default: ""
  String  :tvdb_id, default: ""
  String  :tvrage_id, default: ""

  String    :show_specification, :text => true, default: ""
  TrueClass :heuristic_guess, default: false   # Boolean

  DateTime :created_at, null: false
  DateTime :updated_at
end


DB.create_table(:orders) do
  primary_key :id

  foreign_key :media_item_id, :media_items, null: false

  Integer   :type, null: false, default: 0
  Integer   :season, null: true, default: nil
  Integer   :episode, null: true, default: nil

  Integer   :trakt_state, null: false, default: 0
  TrueClass :trakt_state_synced, default: true   # Boolean

  Integer   :state, null: false, default: 0

  DateTime :created_at, null: false
  DateTime :updated_at
end


DB.create_table(:torrents) do
  primary_key :id

  foreign_key :media_item_id, :media_items, null: true

  String  :infohash, null: false
  index   :infohash, unique: true

  String  :name, null: false
  Integer :state, null: false, default: 0

  DateTime :created_at, null: false
  DateTime :updated_at
end


DB.create_join_table(order_id: :orders, torrent_id: :torrents)


DB.create_table(:torrent_media_files) do
  primary_key :id

  foreign_key :torrent_id, :torrents, null: false

  Text  :filename, null: false
  Text  :subtitle_filename, null: true

  Integer   :season, null: true, default: nil
  Integer   :episode, null: true, default: nil

  # index by season, episode, etc
  index :season, unique: false
  index [:season, :episode], unique: false

  DateTime :created_at, null: false
  DateTime :updated_at
end