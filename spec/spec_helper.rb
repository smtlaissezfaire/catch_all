require 'byebug'
require File.dirname(__FILE__) + '/../lib/catch_all'

RSpec.configure do |config|
  config.expect_with(:rspec) do |c|
    c.syntax = :should
  end

  config.mock_with :rspec do |mocks|
    mocks.syntax = :should
  end
end
