class TorrentCategorizer
  VIDEO_EXTS = %w(3g2 3gp asf avi drc flv flv m2v m4p m4v m4v mkv mng mov mp2 mp4 mpe
    mpeg mpeg mpg mpg mpv mxf net nsv ogg ogv qt rm rmvb roq svi vob vob webm wmv yuv)
  def initialize(name, files)
    @name = name
    @files = files.map {|f| f['path']}
  end

  def is_categorizable_video?
    exts = @files.map {|f| File.extname(f).gsub('.','')}
    exts.uniq!
    info "torrent '#{@name}' exts: [#{exts.join(', ')}]"
    exts.each {|ext| return true if VIDEO_EXTS.include?(ext)}
    false
  end

  def is_tv?

  end

  def is_movie?
  end
end