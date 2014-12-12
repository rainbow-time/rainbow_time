RainbowTime.config.database.file = File.expand_path("db/rainbow.db", File.dirname(__FILE__))
DB = Sequel.sqlite(RainbowTime.config.database.file)
DB.loggers << RainbowTime.config.database.logger

# config.auth.username = 'yourname'
# config.auth.api_key = 'yourkey'
# config.auth.password = 'yoourpass'
require_relative 'auth_config.rb'
