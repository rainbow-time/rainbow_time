require 'sequel/plugins/serialization'
require 'yaml'

class RainbowTime::ShowSubset
  attr_reader :seasons
  def initialize(seasons = {})
    @seasons = seasons
  end
end

Sequel::Plugins::Serialization.register_format(:show_subset_yaml,
  lambda{|object| YAML.dump(object.seasons)},
  lambda{|text| RainbowTime::ShowSubset.new(YAML.load(text))})
