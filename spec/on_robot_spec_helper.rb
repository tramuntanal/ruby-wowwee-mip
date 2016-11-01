require_relative 'spec_helper'

MIP= Wowwee::mip(ENV['MIP_ADDR'])
RSpec.configure do |config|
  config.before(:suite) do
    MIP.stop
  end
  config.after(:suite) do
    MIP.disconnect
  end
end