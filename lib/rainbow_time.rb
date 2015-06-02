require 'logger'
require 'pp'
require 'json'

require 'hashie'

require 'sqlite3'
require 'sequel'
Sequel.extension :inflector

require 'deluge'
require 'nokogiri'
require 'memoist'

require 'typhoeus'

module RainbowTime
end


require_relative 'rainbow_time/ext/core.rb'
# require_relative 'rainbow_time/ext/traktapi.rb'
require_relative 'rainbow_time/ext/hashie.rb'

# require_relative 'rainbow_time/config.rb'
require_relative 'rainbow_time/trakt/trakt_api_error.rb'
require_relative 'rainbow_time/trakt/trakt_api.rb'
# require_relative 'rainbow_time/trakt_state.rb'
require_relative 'rainbow_time/models.rb'
require_relative 'rainbow_time/spiders/order_spider.rb'
