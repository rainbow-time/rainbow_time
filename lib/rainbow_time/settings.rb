require 'hashie'
include Hashie

module RainbowTime
  class << self
    attr_reader :settings, :settings_file_path

    def config_dir
      config_base_dir = if ENV['APPDATA']
        ENV['APPDATA']
      else
        File.join(ENV['HOME'], '.config')
      end
      File.join(config_base_dir, 'rainbow_time')
    end

    def load_settings_file
      @settings_file_path = File.join(config_dir, 'settings.yml')
      if File.exists?(settings_file_path)
        Mash.load(settings_file_path)
      else
        warn "No config file #{settings_file_path}. Using only default settings."
        Mash.new
      end
    rescue Exception => e
      warn "Failed to load config file #{settings_file_path}! Because '#{e.inspect}'. Using only default settings."
      Mash.new
    end

    def default_settings
      Mash.new({
        logfile: 'C:/rainbow_time/run.log',
        config_dir: config_dir,
        moneta_dir: File.join(config_dir, 'moneta'),
        folder: {
          tv: 'TV',
          movies: 'Movies',
          videos: 'Videos',
          finished: 'Finished',
          incomplete: 'Incomplete'
        },
        deluge: {
          connection: {
            host: '127.0.0.1',
            port: '58846',
            login: 'rainbow_time',
            password: 'rainbowrainbowrainbow'
          },
          managed_label: 'rainbow-managed'
        },
        move_completed: false
      })
    end

    def load_settings
      file_settings = load_settings_file
      @settings = default_settings.merge(file_settings)
    end

  end
end