require 'nokogiri'
require 'net/https'


class TorrentCategorizer
  VIDEO_EXTS = %w(3g2 3gp asf avi drc flv flv m2v m4p m4v m4v mkv mng mov mp2 mp4 mpe
    mpeg mpeg mpg mpg mpv mxf net nsv ogg ogv qt rm rmvb roq svi vob vob webm wmv yuv)

  TORRENTZ_SEARCH_BASE_URL = 'https://torrentz.eu/'

  def initialize(hash, name, files)
    @hash = hash
    @name = name
    @files = files.map {|f| f['path']}
    @torrentz_category = nil
  end

  def is_categorizable_video?
    exts = @files.map {|f| File.extname(f).gsub('.','')}
    exts.uniq!
    # debug "torrent '#{@name}' exts: [#{exts.join(', ')}]"
    exts.each {|ext| return true if VIDEO_EXTS.include?(ext)}
    false
  end

  def is_tv?
    categorize_with_torrentz
    return true if @torrentz_category == :tv
    false
  end

  def is_movie?
    return true if @torrentz_category == :movie
    false
  end

  def categorize_with_torrentz
    return if @torrentz_category

    uri = URI.parse(TORRENTZ_SEARCH_BASE_URL + @hash)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(uri.path)
    response = http.request(request)
    html = response.body

    doc = Nokogiri::HTML(html)
    result = doc.css('.download dt a span.n')
    categories = result.map do |e|
      e.next.to_s.strip
    end

    categories = categories.uniq.sort.delete_if {|c| c.empty?}

    is_tv = is_movie = false
    if categories.include?('tv shows') or categories.include?('tv') or categories.include?('television')
      is_tv = true
    end
    if categories.include?('movie') or categories.include?('movies')
      is_movie = true
    end

    if is_tv && !is_movie
      @torrentz_category = :tv
    elsif is_movie && !is_tv
      @torrentz_category = :movie
    else
      @torrentz_category = :unknown
    end
  end
end