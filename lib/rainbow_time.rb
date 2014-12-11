# $debug_http_party = true
require 'trakt_api'
require 'hashie'
require 'deluge'
require 'nokogiri'
require 'active_support/inflector'

require 'pp'

module RainbowTime
end

require_relative 'rainbow_time/ext/core.rb'
require_relative 'rainbow_time/ext/traktapi.rb'
require_relative 'rainbow_time/ext/hashie.rb'

require_relative 'rainbow_time/config.rb'
require_relative 'rainbow_time/log_helper.rb'
require_relative 'rainbow_time/trakt_state.rb'
require_relative 'rainbow_time/data_store.rb'
