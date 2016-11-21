# A queue for managing BLE notifications.
#

module Wowwee
  module Mip
    module Protocol
      class NotifQueue
        # @param receive_data [ReceiveDataService] The service in charge of subscribing to notifications.
        def initialize(device, receive_data_srv)
          @observers= Hash.new
          subscribe_to_notifications(receive_data_srv)
          start_queue_manager(device)
        end

        # Registers one observer to listen for a given command.
        # @param observer [Object] An object responding to #observe.
        # @param cmd_name [sym] The name of the observed command, or
        #   *nil* to register for all commands (which is the default).
        #
        def register_observer(observer, cmd_name=nil)
          codes= []
          if cmd_name
            codes << Protocol.find_cmd_by_name(cmd_name).code
          else
            codes+= CMDS_BY_CODE.keys
          end
          codes.each {|code|
            list= @observers[code]
            if list.nil?
              @observers[code]= list= []
            end
            list.push(observer)
          }
        end
        # Unregisters one observer from listening for a given command.
        # @param observer [Object] The registered observer to remove.
        # @param cmd_name [sym] The name of the observed command.
        #
        def unregister_observer(observer, cmd_name)
          cmd= Protocol.find_cmd_by_name(cmd_name)
          list= @observers[cmd.code]
          list.delete(observer) unless list.nil?
        end

        #-----------------------------------------
        private
        #-----------------------------------------

        # Starts the thread responsible of managing the queue asynchronously.
        def start_queue_manager(device)
          Thread.new {
            loop {
              device.is_connected?
              sleep(0.25)
            }
          }
        end

        # Registers a callback to read cmd responses,
        # The callback persists arribing notifications to the queue.
        # Removes Response prefix bytes which repeat requested cmd code.
        def subscribe_to_notifications(receive_data_srv)
          receive_data_srv.on_notification {|bytes|
            ary= bytes.scan(/../)
            bytes= ary.collect {|hex| hex.to_i(16)}
            cmd= Protocol.find_cmd_by_code(bytes.shift)
            list= @observers[cmd.code]
            unless list.nil?
              list.each { |observer|
                observer.observe(cmd, cmd.rs(bytes))
              }
            end
          }
        end

      end
    end
  end
end
