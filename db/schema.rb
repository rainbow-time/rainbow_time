# http://sequel.jeremyevans.net/rdoc/files/doc/schema_modification_rdoc.html

DB.create_table(:media_items) do
  String  :slug, primary_key: true
  Integer :type, default: 1, null: false # 1 = movie, 2 = show

  String  :title, null: false
  Integer :year, null: false
  String  :trakt_url, null: false

  String  :imdb_id, default: ""
  String  :tmdb_id, default: ""
  String  :tvdb_id, default: ""
  String  :tvrage_id, default: ""

  String  :show_specification, text: true, default: nil
end

