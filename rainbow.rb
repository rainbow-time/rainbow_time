# require 'vcr'

# VCR.configure do |c|
#   c.cassette_library_dir = 'vcr_cassettes'
#   c.hook_into :webmock # or :fakeweb
# end


# VCR.use_cassette('lists') do
# end

require_relative 'lib/rainbow_time/config.rb'
require_relative 'config.rb'
require_relative 'lib/rainbow_time.rb'

# client = TraktApi::Client.new(config.auth)
# state = TraktState.new(client, config)
# state.sync!

# pp state.control_lists_with_items



# pp client.lists.add(name: 'apilist2', privacy: 'private', **username_auth)
# prof = client.user.profile
# pp prof
# lists = client.user.lists(**with_auth)
# p lists
# pp lists.first
# puts lists.first.name

