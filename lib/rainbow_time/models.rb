Sequel::Model.raise_on_save_failure = true

# timestamp everything
Sequel::Model.plugin :timestamps

# http://sequel.jeremyevans.net/rdoc-plugins/classes/Sequel/Plugins/ModificationDetection.html
Sequel::Model.plugin :modification_detection

# validate: column type; NOT NULL columns are present? = true; unique is unique; max length for string columns
Sequel::Model.plugin :auto_validations, :not_null=>:presence

# http://sequel.jeremyevans.net/rdoc-plugins/classes/Sequel/Plugins/ValidationHelpers.html
# http://sequel.jeremyevans.net/rdoc-plugins/classes/Sequel/Plugins/ValidationHelpers/InstanceMethods.html
Sequel::Model.plugin :validation_helpers

# Sequel::Model.plugin :instance_hooks


require_relative 'models/show_specification.rb'
require_relative 'models/show_subset.rb'

require_relative 'models/media_item.rb'
require_relative 'models/movie.rb'
require_relative 'models/show.rb'
require_relative 'models/order.rb'
require_relative 'models/torrent.rb'
require_relative 'models/torrent_media_file.rb'

