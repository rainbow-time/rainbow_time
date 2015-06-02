require 'rspec'
require 'factory_girl'
require 'vcr'

require_relative '../rainbow.rb'
require_relative 'fixtures/factories/all.rb'

include RainbowTime

VCR.configure do |c|
  c.cassette_library_dir = 'fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata! # name cassettes automatically based on rspec example name
end


RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  config.expect_with :rspec do |expect|
    expect.syntax = :expect
  end

  # rollback sequel
  config.around(:each) do |example|
    DB.transaction(:rollback=>:always, :auto_savepoint=>true){example.run}
  end


end
