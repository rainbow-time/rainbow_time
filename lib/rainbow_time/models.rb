class Sequel::Model
  raise_on_save_failure = true

  # timestamp everything
  plugin :timestamps

  # http://sequel.jeremyevans.net/rdoc-plugins/classes/Sequel/Plugins/ModificationDetection.html
  plugin :modification_detection

  # validate: column type; NOT NULL columns are present? = true; unique is unique; max length for string columns
  plugin :auto_validations, :not_null=>:presence

  # http://sequel.jeremyevans.net/rdoc-plugins/classes/Sequel/Plugins/ValidationHelpers.html
  # http://sequel.jeremyevans.net/rdoc-plugins/classes/Sequel/Plugins/ValidationHelpers/InstanceMethods.html
  plugin :validation_helpers

  # Add boolean attribute? methods for all columns of type :boolean
  # in all model subclasses (called before loading subclasses)
  plugin :boolean_readers

  #   plugin :instance_hooks
  # def self.skip_type_auto_validation(*columns)
  #   @skip_type_auto_validation_columns ||= []
  #   @skip_type_auto_validation_columns += columns
  #   self.skip_auto_validations :types
  #   self.send(:define_method, :validate) do
  #     super()
  #     columns_to_skip = self.class.instance_variable_get("@skip_type_auto_validation_columns")
  #     validates_schema_types(keys - columns_to_skip)
  #   end
  # end


  # defines enum values backed by integer colum
  def self.enum(column, *values)
    @enums ||= {}
    values = values.flatten
    @enums[column] = values

    self.send(:define_method, "#{column}") do
      index = super()
      enums = self.class.instance_variable_get("@enums")
      enums[column][index]
    end

    self.send(:define_method, "#{column}?") do |val|
      self.send(column) == val
    end

    self.send(:define_method, "#{column}=") do |enum_value|
      enums = self.class.instance_variable_get("@enums")
      index = enums[column].index(enum_value)
      if index
        super(index)
      else
        self.db.send(:log_each, :warn, "invalid value '#{enum_value}' for #{self.class}.#{column} pk=#{pk}")
      end
    end

    # skip auto validation for enums
    self.skip_auto_validations :types
    self.send(:define_method, :validate) do
      super()
      columns_to_skip = self.class.instance_variable_get("@enums").keys
      validates_schema_types(keys - columns_to_skip)
    end

    values.each_with_index do |val, index|
      self.subset("#{column}_is_#{val}".to_sym, column => index)
    end

  end
end

require_relative 'models/show_specification.rb'

require_relative 'models/media_item.rb'
require_relative 'models/movie.rb'
require_relative 'models/show.rb'
require_relative 'models/order.rb'
require_relative 'models/torrent.rb'
require_relative 'models/torrent_media_file.rb'

