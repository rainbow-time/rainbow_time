class Logger
  def log(level, msg)
    puts "#{Time.timestamp} #{level}  #{msg}"
  end
end

def error(msg)
  Logger.new.log('INFO', msg)
end


def info(msg)
  Logger.new.log('INFO', msg)
end

def debug(msg)
  Logger.new.log('DEBUG', msg)
end
