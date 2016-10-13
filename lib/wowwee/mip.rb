require 'ble'
require_relative '../ble_bootstrap'
require_relative 'mip/version'
require_relative 'mip/robot'

#
# The Mip protocol can be found here: https://github.com/WowWeeLabs/MiP-BLE-Protocol
#
module Wowwee

  class ConnectionFailed < Exception; end

  def self.mip(ble_address)
    device= BLE::Bootstrap.new.start_session(ble_address)
    raise ConnectionFailed, "Is adapter up?" unless device.is_connected?
    Wowwee::Mip::Robot.new(device)
  end

  module Mip
  end
end
