require 'nokogiri'
require_relative 'simple_http.rb'

require 'concurrent'


class TorrentCategorizer
  attr_reader :category

  VIDEO_EXTS = %w(3g2 3gp asf avi drc flv flv m2v m4p m4v m4v mkv mng mov mp2 mp4 mpe
    mpeg mpeg mpg mpg mpv mxf net nsv ogg ogv qt rm rmvb roq svi vob vob webm wmv yuv)

  TORRENTZ_SEARCH_BASE_URL = 'https://torrentz.eu/'
  TORRENTHOUND_HASH_BASE_URL = 'http://www.torrenthound.com/hash/'
  GETSTRIKE_HASH_BASE_URL = 'https://getstrike.net/api/v2/torrents/info/?hashes='
  # http://www.torrenthound.com/hash/6974B5D090AF2C138D0D4F83670DC9D89D62E812
  # https://getstrike.net/api/v2/torrents/info/?hashes=6974B5D090AF2C138D0D4F83670DC9D89D62E812

  def initialize(hash, name, files)
    @hash = hash
    @name = name
    @files = files.map {|f| f['path']}
    @category = nil

    @categorizable_video_files = @files.select do |file|
      file_ext = File.extname(file).gsub('.','')
      VIDEO_EXTS.include?(file_ext)
    end
  end

  def categorizable_names
    [@name] + @categorizable_video_files 
  end

  def process!
    # default
    @category = :unknown

    if @categorizable_video_files.empty?
      @category = :non_video
      return
    end

    strict_heuristic = category_from_strict_heuristic
    # strict_heuristic = nil
    
    # strict_heuristic overrules other stuff
    if strict_heuristic
      @category = strict_heuristic
      # return
    end

    # @category = category_from_torrentz
    # debug "Torrentz says type '#{@category}' for '#{@name}' [#{@hash}]"
    debug "Final determined type '#{@category}' for '#{@name}' [#{@hash}]"
  end

  def category_from_strict_heuristic
    names = categorizable_names
    names.each do |name|
      return :tv if match_tv_strict_heuristic(name)
    end

    # only TV can be determined this way
    nil
  end

  def match_tv_strict_heuristic(name)
    sep = /[X._\- ]/
    
    name = name.sub(/\..{1,4}$/,'').upcase
    case name
    # SEASON 01 EPISODE 01
    # SEASON.1-EPISODE.2
    when /\bSEASON#{sep}+\d+#{sep}+EPISODE#{sep}+\d+\b/
      true
    # S01.E02
    # S2010E01
    # S01E01
    # S01E01A
    when /\bS\d+#{sep}*E\d+\w?/
      true
    else
      false
    end
  end

  def category_from_torrentz
    found_categories = []
    html = SimpleHTTP.get(TORRENTZ_SEARCH_BASE_URL + @hash)
    doc = Nokogiri::HTML(html)

    result = doc.css('.download dt a span.n')
    
    categories = result.map do |e|
      e.next.to_s.strip
    end

    categories = categories.uniq.sort.delete_if {|c| c.empty?}


    if categories.include?('tv shows') or categories.include?('tv') or categories.include?('television')
      found_categories << :tv
    end

    if categories.include?('movie') or categories.include?('movies')
      found_categories << :movie
    end

    if found_categories.count == 1
      # there can be only 1 valid category
      found_categories.first
    else
      nil
    end
  end

  def category_from_torrenthound
    html = SimpleHTTP.get(TORRENTHOUND_HASH_BASE_URL + @hash)
    puts html
    doc = Nokogiri::HTML(html)
    # puts 
  end

  def category_from_strike
  end

  def category_from_kickass
    nil
  end
end