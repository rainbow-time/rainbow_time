require 'pp'

module RainbowTime; end

require_relative 'rainbow_time/log_helpers.rb'
RainbowTime::LogHelpers.set_global_logger($stdout)

info "Welcome to hellscape!"

require_relative 'rainbow_time/settings.rb'
RainbowTime.load_settings
pp RainbowTime.settings
exit

config_path = ENV['APPDATA'] + '\rainbow_time\settings.yml'
debug "pwd: #{Dir.pwd}"
debug "config file: #{config_path}"

settings = nil

if File.exists?(config_path)
  settings = YAML.load(File.read(config_path))
else
  warn "No config file. Using only default settings."
  settings = {}
end


settings['logfile'] ||= 'C:\rainbow_time\run.log'

settings['deluge_host'] ||= '127.0.0.1'
settings['deluge_port'] ||= '58846'
settings['deluge_user'] ||= 'rainbow_time'
settings['deluge_pass'] ||= 'rainbowrainbowrainbow'
settings['deluge_label'] ||= 'rainbow-managed'

settings['tv_dir'] ||= 'TV'
settings['movies_dir'] ||= 'Movies'
settings['move_completed'] ||= nil # set to dir to keep done and categorized in separate dir

debug "Settings (file and defaults): "
debug settings.inspect


exit
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
