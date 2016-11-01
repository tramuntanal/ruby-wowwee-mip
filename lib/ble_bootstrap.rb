module BLE
  # A service for bootstraping connection to BLE devices.
  class Bootstrap

    def self.list_adapters
      puts BLE::Adapter.list
    end
    def initialize(adapter='hci0')
      @a = BLE::Adapter.new(adapter)
    end

    def show_adapter_info
      puts "Info: #{@a.iface}"
      puts "Info: #{@a.name}"
      puts "Info: #{@a.address}"
    end

    # Run discovery
    def run_discovery
      @a.start_discovery
      sleep(2)
      @a.stop_discovery
      puts "Devices found: #{@a.devices}"
      #    @a.devices.each {|address|
      #      d= @a[address]
      #      puts "Device found: #{d.address}::#{d.name}"
      #    }
    end

    def find_device_by_name(device_name_to_connect)
      dev= nil
      @a.devices.find {|address|
        dev= @a[address]
        dev.name == device_name_to_connect
      }
      dev
    end
    def find_device_by_address(address)
      dev= @a[address]
      puts "paired??#{dev.is_paired?}"
      puts "is_connected??#{dev.is_connected?}"
      puts "is_trusted??#{dev.is_trusted?}"
      puts "is_blocked??#{dev.is_blocked?}"
      dev
    end

    def explore_device(device)
      puts ">>>RSSI:#{device.rssi}"
      dev.services.each do |srv_id|
        show_device_service_chars(device, srv_id)
        puts "------------------------------------------"
      end
      #  puts "========================"
      #  mgr.show_device_service_chars(dev, :device_information)
      #  puts "========================"
      #  mgr.show_device_service_chars(dev, :battery_service)
      #  puts "========================"
      #  mgr.explore_device(dev)
      #    mgr.show_device_service_chars(dev, Wowwee::Mip::Protocol::SendDataService::WRITE)
    end
    def show_device_service_chars(device, srv_id)
      puts "Service[#{srv_id}]::#{BLE::Service[srv_id]}"
      chars= device.characteristics(srv_id)
      chars.each {|uuid|
        info  = BLE::Characteristic[uuid]
        name  = info.nil? ? uuid : info[:name]
        value = device[srv_id, uuid] rescue '/!\\ not-readable /!\\'
        puts "%-30s: %s" % [ name, value ]
      }
    end

    # Get device and connect to it
    def start_session(device_address, async_ops: true)
      dev= find_device_by_address(device_address)
      puts "Device<address:#{dev.address}, Name:#{dev.name}>"
      #      dev.pair unless dev.is_paired?
      if dev.is_connected?
        puts "Device already connected!"
      else
        begin
          puts 'connecting...'
          dev.connect
          raise BLE::Device::NotConnected unless dev.is_connected?
        rescue Exception => e
          puts "Connection failed due to:#{e.class} #{e.message}"
          puts e.backtrace
        end
      end

      #      if async_ops
      #        run_events_thread
      #      end
      dev
    end
    #    # Required for receiveing notifications
    #    def run_events_thread
    #      Thread.new {
    #        main= DBus::Main.new
    #        main << BLE::DBUS
    #        main.run
    #      }
    #    end

  end
end
