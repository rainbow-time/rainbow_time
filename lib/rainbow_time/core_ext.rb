require 'pp'
require 'ostruct'

module Kernel
  def to_os
    OpenStruct.new(self)
  end

  def info(s)
    $logger.info(s)
  end

  def debug(s)
    $logger.debug(s)
  end

  def warn(s)
    $logger.warn(s)
  end

  def error(s)
    $logger.error(s)
  end

  def fatal(s)
    $logger.fatal(s)
  end
end