module Wowwee
  module Mip
    module Protocol

      #
      # Send Data Service: 0xFFE5
      #   Send Data WRITE Characteristic: 0xFFE9
      #
      class SendDataService
        UUID= '0000ffe5-0000-1000-8000-00805f9b34fb'
        BLE::Service.add UUID,
          name: 'Send Data Service',
          type: 'wowwee.mip.protocol.service.send_data'
        module Characteristics
          WRITE= '0000ffe9-0000-1000-8000-00805f9b34fb'
          BLE::Characteristic.add WRITE,
            name: 'write',
            type: 'wowwee.mip.protocol.characteristic.write',
            out: ->(cmd) { cmd.to_s }
        end
        def initialize(dev)
          @device= dev
        end
        def send(cmd)
          @device.[]=(UUID, Characteristics::WRITE, cmd)
        end
        def write(data)
          @device.[]=(UUID, Characteristics::WRITE, data, {raw: true})
        end
      end

      #
      # Receive Data Service: 0xFFE0
      #   Receive Data NOTIFY Characteristic: 0xFFE4
      #
      class ReceiveDataService
        UUID= '0000ffe0-0000-1000-8000-00805f9b34fb'
        BLE::Service.add UUID,
          name: 'Receive Data Service',
          type: 'wowwee.mip.protocol.service.receive_data'
        module Characteristics
          NOTIFY= '0000ffe4-0000-1000-8000-00805f9b34fb'
          BLE::Characteristic.add NOTIFY,
            name: 'notify',
            type: 'wowwee.mip.protocol.characteristic.notify'
        end
        def initialize(dev)
          @device= dev
          @device.start_notify!(UUID, Characteristics::NOTIFY)
        end
        def read
          @device[UUID, Characteristics::NOTIFY]
        end
        def on_notification(&callback)
          @device.on_notification(UUID, Characteristics::NOTIFY, &callback)
        end
      end

    end

  end
end