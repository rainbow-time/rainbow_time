# http://sequel.jeremyevans.net/rdoc/files/doc/schema_modification_rdoc.html

DB.create_table(:artists) do
  primary_key :id
  String :name
end

puts DB.tables

