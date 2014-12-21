require 'logger'
require 'pp'

# $debug_http_party = true
require 'trakt_api'
require 'hashie'

require 'sqlite3'
require 'sequel'

require 'deluge'
require 'nokogiri'
require 'memoist'


module RainbowTime
end

require_relative 'rainbow_time/ext/core.rb'
require_relative 'rainbow_time/ext/traktapi.rb'
require_relative 'rainbow_time/ext/hashie.rb'

# require_relative 'rainbow_time/config.rb'
require_relative 'rainbow_time/trakt_state.rb'
require_relative 'rainbow_time/models.rb'
require_relative 'rainbow_time/spiders/order_spider.rb'
