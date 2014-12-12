require 'hashie'
require 'logger'
require 'sequel'

module RainbowTime
  @config = Hashie::Mash.new
  @config.auth = Hashie::Mash.new
  @config.lists = Hashie::Mash.new
  @config.database = Hashie::Mash.new

  # TODO: config.lists.missing_items = 'Missing Items'
  @config.lists.orders = 'Rainbow Orders' # want this movie/show/season/episode
  @config.lists.subscriptions = 'Rainbow Subscriptions'
  @config.lists.processed_orders = 'Processed Rainbow Orders'

  @config.database.file = File.expand_path(".config/rainbow/rainbow.db", ENV['HOME'])
  @config.database.logger = Logger.new($stdout)
  @config.database.logger.progname = '{sequel}'

  @config.logger = Logger.new($stdout)

  @config.logger.formatter = proc do |severity, datetime, progname, msg|
    "#{datetime.timestamp} #{severity} #{progname} #{msg}\n"
  end

  def self.config
    @config
  end
end