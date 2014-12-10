# $debug_http_party = true
require 'trakt_api'
require 'deluge'
require 'nokogiri'
require 'active_support/inflector'

require 'pp'

# namespace module
module RainbowTime;end

require 'rainbow_time/core_ext.rb'
require 'rainbow_time/traktapi_ext.rb'
require 'rainbow_time/log_helper.rb'
require 'rainbow_time/trakt_state.rb'
require 'rainbow_time/data_store.rb'
