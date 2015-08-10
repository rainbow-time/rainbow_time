require 'hashie/mash'

module RainbowTime
  class << self
    attr_reader :settings, :settings_file_path

    def load_settings_file
      config_base_dir = if ENV['APPDATA']
        ENV['APPDATA']
      else
        File.join(ENV['HOME'], '.config')
      end

      @settings_file_path = File.join(config_base_dir, 'rainbow_time/settings.yml')
      if File.exists?(settings_file_path)
        YAML.load(File.read(settings_file_path))
      else
        warn "No config file #{settings_file_path}. Using only default settings."
        {}
      end
    rescue Exception => e
      warn "Failed to load config file #{settings_file_path}! Using only default settings."
      {}
    end

    def load_settings
      @settings = load_settings_file
      @settings = {a: "20"}
    end

  end
end