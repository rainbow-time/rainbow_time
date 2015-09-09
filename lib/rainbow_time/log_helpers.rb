require 'logger'

module RainbowTime::LogHelpers
  def self.pretty_log_formatter
    proc do |severity, datetime, progname, msg|
      # date_format = datetime.strftime("%Y-%m-%d %H:%M:%S")
      date_format = datetime.strftime("%H:%M:%S")
      if severity == "INFO" or severity == "WARN"
        # "[#{date_format}] #{severity}  (#{progname}): #{msg}\n"
        "[#{date_format}] #{severity}  : #{msg}\n"
      else
        # "[#{date_format}] #{severity} (#{progname}): #{msg}\n"
        "[#{date_format}] #{severity} : #{msg}\n"
      end
    end
  end

  def self.set_global_logger(io)
    $logger = Logger.new(io)
    $logger.formatter = pretty_log_formatter
    $logger.level = Logger::INFO
    $logger.level = Logger::DEBUG
  end
end