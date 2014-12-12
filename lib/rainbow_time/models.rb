DB = Sequel.sqlite(RainbowTime.config.database.file)
DB.loggers << RainbowTime.config.database.logger

# timestamp everything
Sequel::Model.plugin :timestamps

# http://sequel.jeremyevans.net/rdoc-plugins/classes/Sequel/Plugins/ModificationDetection.html
Sequel::Model.plugin :modification_detection

# validate: column type; NOT NULL columns are present? = true; unique is unique; max length for string columns
Sequel::Model.plugin :auto_validations, :not_null=>:presence

# http://sequel.jeremyevans.net/rdoc-plugins/classes/Sequel/Plugins/ValidationHelpers.html
Sequel::Model.plugin :validation_helpers

require_relative 'models/order.rb'
require_relative 'models/media_item.rb'