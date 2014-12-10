module RainbowTime
  @config =  Hashie::Mash.new
  @config.auth = Hashie::Mash.new
  @config.lists = Hashie::Mash.new

  # TODO: config.lists.missing_items = 'Missing Items'
  @config.lists.orders = 'Rainbow Orders' # want this movie/show/season/episode
  @config.lists.subscriptions = 'Rainbow Subscriptions'
  @config.lists.processed_orders = 'Processed Rainbow Orders'

  @config.data_store_dir = File.expand_path(".config/rainbow-data-store", ENV['HOME'])

  def self.config
    @config
  end
end