module RainbowTime; end

require_relative 'rainbow_time/core_ext.rb'
require_relative 'rainbow_time/log_helpers.rb'
require_relative 'rainbow_time/settings.rb'


RainbowTime::LogHelpers.set_global_logger($stdout)
info "Welcome to hellscape!"

RainbowTime.load_settings
debug "Using settings: \n" + RainbowTime.settings.pretty_inspect

require_relative 'rainbow_time/main_loop.rb'

module RainbowTime
  attr_reader :main_loop

  def self.start
    @main_loop = MainLoop.new
    @main_loop.run
  end
end

