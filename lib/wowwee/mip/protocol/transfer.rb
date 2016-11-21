require_relative 'services'
require_relative 'commands'
require_relative 'notif_queue'
module Wowwee
  module Mip
    module Protocol

      # Transfer layer is an adapter to the underlaying way to connect to the device.
      # In this case BLE through Bluez's DBus interface.
      class Transfer
        def initialize device, robot_state
          @device= device
          @robot_state= robot_state
          @send_data= Protocol::SendDataService.new(device)
          @receive_data= Protocol::ReceiveDataService.new(device)
          @queue= NotifQueue.new(@device, @receive_data).register_observer(@robot_state)
        end

        def send(cmd_name, data=nil)
          cmd= Protocol.find_cmd_by_name(cmd_name)
          @send_data.send(cmd.rq(data))
        end

        def read_new(cmd_name)
          now= Time.now
          send(cmd_name)
          @robot_state.read_new(cmd_name, now)
        end

      end
    end
  end
end
