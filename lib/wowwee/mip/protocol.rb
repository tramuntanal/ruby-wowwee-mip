require_relative 'protocol/cmd'
require_relative 'protocol/robot_state'
require_relative 'protocol/cmd_value'
module Wowwee
  module Mip
    #
    # The Mip phisical robot has Bluetooth Low Energy (BLE).
    # So the protocol is a GATT protocol.
    # Good explanation of ATT and GATT concepts: https://epxx.co/artigos/bluetooth_gatt.html
    #
    # Each Attribute corresponds to a service and CMDs are values of the service,
    # then commands are Attribute values.
    #
    module Protocol

      class UnexpectedResponse < Exception; end

      CMDS_BY_CODE= {}
      CMDS_BY_NAME= {}

      def self.cmd(code, name, preprocessor: nil, postprocessor: nil)
        cmd= Cmd.new(code, name, preprocessor, postprocessor)
        CMDS_BY_CODE[code]= cmd
        CMDS_BY_NAME[name]= cmd
      end
      def self.find_cmd_by_name(cmd_name)
        CMDS_BY_NAME[cmd_name]
      end
      def self.find_cmd_by_code(code)
        CMDS_BY_CODE[code]
      end

      class Ble
        def initialize(ble_device)
          @device= ble_device
          @state= RobotState.new
          @transfer= Protocol::Transfer.new(@device, @state)
        end

        def send(cmd_name, data=nil)
          @transfer.send(cmd_name, data)
        end
        def read(cmd_name)
          cmd_value= @transfer.read_new(cmd_name)
          cmd_value.value
        end
      end

    end
  end
end
require_relative 'protocol/transfer'
require_relative 'protocol/odo_calc'
