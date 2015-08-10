require 'pp'

module RainbowTime; end

require_relative 'rainbow_time/log_helpers.rb'
RainbowTime::LogHelpers.set_global_logger($stdout)

info "Welcome to hellscape!"

require_relative 'rainbow_time/settings.rb'
RainbowTime.load_settings
debug "Final settings: \n" + RainbowTime.settings.pretty_inspect

begin
  require_relative 'deluge_supervisor.rb'
  supe = DelugeSupervisor.new(settings)
  supe.process_torrents
  # supe.list_torrent_contents
  # supe.test_rename_and_move
  # supe.test_get_torrent_label
rescue Exception => e
  error e.inspect
  error e.backtrace
  exit 1
end
