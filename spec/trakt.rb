require_relative '../rainbow.rb'
client = TraktApi::Client.new(RainbowTime.config.auth)
state = RainbowTime::TraktState.new(client, RainbowTime.config)
state.sync!

pp state.control_lists_with_items