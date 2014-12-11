require_relative '../rainbow.rb'
require 'rspec'

RSpec.configure do |config|
  config.expect_with :rspec do |expect|
    expect.syntax = :expect
  end
end

