require 'sequel/plugins/serialization'
require 'yaml'

class RainbowTime::ShowSpecification
  attr_reader :seasons
  def initialize(seasons = {})
    @seasons = seasons
  end
end

Sequel::Plugins::Serialization.register_format(:show_specification_yaml,
  lambda{|object| YAML.dump(object.seasons)},
  lambda{|text| RainbowTime::ShowSpecification.new(YAML.load(text))})
