require 'rspec'
require 'factory_girl'

require_relative '../rainbow.rb'
require_relative 'factories/all.rb'

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
