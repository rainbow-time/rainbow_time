require_relative 'spec_helper.rb'

describe 'TraktState' do
  it 'synchronizes control lists' do
    client = TraktApi::Client.new(RainbowTime.config.auth)
    state = RainbowTime::TraktState.new(client, RainbowTime.config)
    state.sync!

    pp state.control_lists_with_items
  end
end