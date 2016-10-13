$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'wowwee/mip'
require "rspec/expectations"

MIP= Wowwee::mip(ENV['MIP_ADDR'])
RSpec.configure do |config|
  config.before(:suite) do
    MIP.stop
  end
  config.after(:suite) do
    MIP.disconnect
  end
end