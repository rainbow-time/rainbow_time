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

settings['logfile'] ||= 'C:\rainbow_time\run.log'

puts "Settings (file and defaults): "
pp settings


begin
  require_relative '../lib/deluge_supervisor.rb'
  supe = DelugeSupervisor.new(settings)
  supe.sayhi
rescue Exception => e
  pp e
  puts e.backtrace
  exit 1
end
