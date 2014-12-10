class RainbowTime::Logger
  def log(level, msg)
    puts "#{Time.timestamp} #{level}  #{msg}"
  end
end

def error(msg)
  RainbowTime::Logger.new.log('INFO', msg)
end


def info(msg)
  RainbowTime::Logger.new.log('INFO', msg)
end

def debug(msg)
  RainbowTime::Logger.new.log('DEBUG', msg)
end
