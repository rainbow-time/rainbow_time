require 'pp'
require 'yaml'
require 'logger'
require_relative '../lib/log_helpers.rb'


puts "Welcome to hellscape!"

config_path = ENV['APPDATA'] + '\rainbow_time\settings.yml'
puts "pwd: #{Dir.pwd}"
puts "config file: #{config_path}"

settings = nil

if File.exists?(config_path)
  settings = YAML.load(File.read(config_path))
else
  puts "No config file. Using only default settings."
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

puts "Settings (file and defaults): "
pp settings

$logger = Logger.new($stdout)
$logger.formatter = pretty_log_formatter


begin
  require_relative '../lib/deluge_supervisor.rb'
  supe = DelugeSupervisor.new(settings)
  supe.process_torrents
  # supe.list_torrent_contents
  # supe.test_rename_and_move
  # supe.test_get_torrent_label
rescue Exception => e
  pp e
  puts e.backtrace
  exit 1
end
