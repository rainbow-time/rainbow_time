config = mash
config.auth = mash
config.lists = mash



config.lists.orders = 'Rainbow Orders' # want this movie/show/season/episode
config.lists.subscriptions = 'Rainbow Subscriptions'
config.lists.processed_orders = 'Processed Rainbow Orders'
# TODO: config.lists.missing_items = 'Missing Items'


config.data_store_dir = File.expand_path("../rainbow-data-store", File.dirname(__FILE__))



# config.auth.username = 'yourname'
# config.auth.api_key = 'yourkey'
# config.auth.password = 'yoourpass'
require_relative 'auth_config.rb'
