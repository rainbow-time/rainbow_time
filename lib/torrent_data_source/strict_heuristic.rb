class TorrentInfoSource::StrictHeuristic
  def self.category(names)
    names.each do |name|
      return :tv if match_tv_strict_heuristic(name)
    end

    # only TV can be determined this way
    :unknown
  end

  def self.match_tv_strict_heuristic(name)
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
end
