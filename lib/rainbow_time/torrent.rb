# module TorrentInfoSource
# end

# dirname = File.basename(__FILE__)
# info_sources = Dir.glob("#{dirname}/torrent_info_source/*.rb")
# info_sources.each do |path|
#   require path
# end

require 'dbm'
require 'moneta'
require 'ostruct'


class RainbowTime::Torrent
  attr_reader :deluge, :http, :id

  module Priorities
    DONT_DOWNLOAD = 0
    NORMAL = 1
    HIGH = 5
    HIGHEST = 7
  end
  attr_reader :deluge, :http, :id

  def initialize(deluge, http, hash_id)
    @deluge = deluge
    @http = http
    @id = hash_id
    @moneta = Moneta.new(:File, RainbowTime.settings.moneta_dir)
    store_load
    persist
  end

  def process
    puts "processing: #{name}"
  end

  def deluge_fields(fields)
    core.get_torrent_status(id, fields)
  end

  def deluge_value(field)
    deluge_fields([field])[field]
  end


  def load(field)
    @moneta[id][field.to_sym]
  end

  def save(field, value)
    o = @moneta[id]
    o[field.to_sym] = value
    @moneta[id] = o
  end



  def files
    results = []
    obj = deluge_fields(%w(files file_priorities file_progress))
    obj['files'].each do |f|
      i = f['index']
      results << {path: f['path'], size: f['size'], priority: obj['file_priorities'][i], progress: obj['file_progress'][i]}
    end
    results
  end

  def name
    deluge_value 'name'
  end

  def label
    deluge_value 'label'
  end

  def core
    deluge.core
  end
end