require 'pp'
require 'yaml'
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

settings['categorized_dir'] ||= 'D:\Categorized'
settings['logfile'] ||= 'C:\rainbow_time\run.log'
settings['deluge_user'] ||= 'rainbow_time'
settings['deluge_pass'] ||= 'rainbowrainbowrainbow'

puts "Settings (file and defaults): "
pp settings

begin
  require_relative '../lib/deluge_supervisor.rb'
  supe = DelugeSupervisor.new(settings)
  supe.sayhi
  # supe.list_torrent_contents
  supe.test_rename_and_move
rescue Exception => e
  pp e
  puts e.backtrace
  exit 1
end
