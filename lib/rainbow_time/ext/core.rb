module Kernel
  def mash(object = {})
    case object
    when Hash
      Hashie::Mash.new(object)
    when Array
      object.map {|e| mash(e)}
    else
      object
    end
  end
end

class Time
  def self.timestamp
    self.now.strftime("%F %T")
  end
end


class String
  def clean_dashes
    self.downcase
      .gsub(/\s+|\[/, '-') # whitespace to dashes
      .gsub(/-+/,'-') # no multiple dashes
      .gsub(/[^0-9A-Za-z-]/, '') # delete all other characters
      .gsub(/^-|-$/, '') # no dashes at beginning or end
  end
end