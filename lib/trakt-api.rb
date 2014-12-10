# $debug_http_party = true
require 'trakt_api'
require 'pp'
require 'hashie'
require 'nokogiri'

require './log_helper.rb'
require './trakt_state.rb'

# nice gem for config: https://github.com/phoet/confiture



def mash(object = {})
  case object
  when Hash
    Hashie::Mash.new(object)
  when Array
    object.map {|e| mash(e)}
  else
    object
  end
end


module ManagedApi
  def response
    debug "#{@method} #{@uri} with #{request_options}"
    # todo: safe to retry several times here
    http_party_response = super
    code = http_party_response.code
    debug "returned #{code}"

    if code.to_s !~ /2\d\d/
      text = http_party_response.parsed_response
      if text =~ /!DOCTYPE/
        debug Nokogiri::HTML(text).to_html
      else
        debug text
      end
      failure =  "#{@method} #{@uri} #{request_options} returned #{code}"
      error failure
      raise failure
    end

    mash(http_party_response.parsed_response)
  end
end

class TraktApi::Base
  prepend ManagedApi
end


config = mash
config.auth = mash
config.lists = mash


config.lists.orders = 'Rainbow Orders' # want this movie/show/season/episode
config.lists.subscriptions = 'Rainbow Subscriptions'
config.lists.processed_orders = 'Processed Rainbow Orders'
#config.lists.missing_items = 'Missing Items' # TODO: add unfound movies. add specific missing seasons and episodes


# trakt state transition
# yes! go from trakt down. but trakt is unreliable!
# long outages even

# maybe have a trakt replica and log? - things to do to trakt?
# on sync, try to update replicate, try to apply log to trakt. log that fails to apply to trakt instead apply for replica?
# or fuck trakt completely?


# queues: 'Download' and 'Subscribed'
# sinks: 'In Progress', Completed', 'Not Found'

# transitions:
# a



# max trakt use:



# with_auth = {username: config.auth.username, auth: true}

# require 'vcr'

# VCR.configure do |c|
#   c.cassette_library_dir = 'vcr_cassettes'
#   c.hook_into :webmock # or :fakeweb
# end



# TODO: scrape API key
# VCR.use_cassette('lists') do
  client = TraktApi::Client.new(config.auth)

  state = TraktState.new(client, config)
  state.sync!
# end

pp state.control_lists_with_items



# # pp client.lists.add(name: 'apilist2', privacy: 'private', **username_auth)
# prof = client.user.profile
# pp prof
# lists = client.user.lists(**with_auth)
# p lists
# pp lists.first
# puts lists.first.name



## representations
=begin

trakt json objects: type/name/ids/season/episodes/year/everything
torrent hashid

many to many

one show/season can have many season/episode torrents
each episode in torrent needs to be marked when complete and renamed




can one torrent contain two trakt items?
simple case is no: episodes get downloaded as single episode torrents, seasons as season torrents
advanced case is yes: episodes could be downloaded via a season torrent
not doing advanced but data structure should support it.


each item is fulfilled by some torrents
each torrent one item that caused it to start (advanced: few items)
each file in a torrent needs a state machine (for knowing when moving at very least)
each file in a torrent belongs to an item

sqlite with active record? or flat files active record (active hash):
https://github.com/zilkey/active_hash



item is a movie/show/season/episode
torrent has many torrent-files

torrent-file properties:
 type(movie or episode)

torrent-file belongs to item



requestitem(movie/show/season/episode)
requestitem has many suppliers
supplier is a torrent

meh



torrent has files
each file is movie or episode
each file is moved when complete
requestitem is finished when all files have been moved

mediaspec: abstract idea. specifies a movie, an episode, a season, or a show (M) or (T, Simpsons) or (T, South Park, 12, 1)
each torrent video file has a spec. each requestitem has a spec

torrent spec is simple. requestitem spec is complex

requestitem knows full detailed spec (T, South Park, 1, 1), (T, South Park, 1, 2), etc all the way to last episode last season

rainbow-time finds a torrent and gives it specs


too abstracts!!!!!

----- flow ----------
add torrent. file list guessed from title
for movie store movie info with torrent
for show store all the episodes torrent contains
[maybe try to match after start - fuck it, no assume torrent name is not mistaken. keep it simple!]


loaded request item. for show get full season/episode list
search for torrents to match it
found a movie: simple one torrent. all one to one
store all the torrent ids needed to fulfill the request. when all torrents at 100% we're done.
if continuing show store in continuing show index to find any new episodes


3 indexes?

a) torrents with metadata about their contents but not their fate. broadest metadata: movie, series name #, season(s) #(s) or episode #
b) request items with detailed content metadata (episode list constituting it basically). and torrents supposed to fulfil that list
c) waiting list. metadata for waiting shows. contains list of downloaded episodes and ones not downloaded. keeps trying to download forever.


SQL/HashFiles/Json from Trakt


MediaSpec (MovieID, ShowID, Season #, Episode#) # depending what's set we have an object type




simples possible

----------------


torrents:
  hashid folder
  info.json (type is show|season|episode, season #, episode #, artwork, show name)


request_items (human name.year.channel.-season-episode) - unambiguous human name
  torrents.json (hashid + what part of it covers)
  request.json (all about what we want, are we watching for new episodes) # only for shows
  completion.json (all we have completed)
  if watch = true and show has

  info.json (all about what the show or the movie is)


wait_items (human name.year.channel)






stateless
---------

keep torrent state (what it covers), everything else from trakttv?
cache show and stuff in memory with 6 hours



=end
