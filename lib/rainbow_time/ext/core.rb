Sequel.extension :inflector
Sequel.extension :blank

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

  def error(msg)
    RainbowTime.config.logger.error(msg)
  end

  def warn(msg)
    RainbowTime.config.logger.warn(msg)
  end

  def info(msg)
    RainbowTime.config.logger.info(msg)
  end

  def debug(msg)
    RainbowTime.config.logger.debug(msg)
  end
end

class Time
  def self.timestamp
    self.now.timestamp
  end

  def timestamp
    self.strftime("%F %T")
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