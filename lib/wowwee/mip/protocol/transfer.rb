require_relative 'services'
require_relative 'commands'
module Wowwee
  module Mip
    module Protocol
      class Transfer
        def initialize device
          @device= device
          @send_data= Protocol::SendDataService.new(device)
          @receive_data= Protocol::ReceiveDataService.new(device)
        end

        def send(cmd_name, data=nil)
          cmd= Protocol.find_cmd_by_name(cmd_name)
          @send_data.send(cmd.rq(data))
        end

        # Registers a callback to read cmd response,
        # then sends cmd and waits for the notification.
        # Timeouts in 5sec, in this case returns nil.
        # @param rq [? < Protocol::BaseCmd::Rq] the request to perform.
        def read_notif(cmd_name)
          cmd= Protocol.find_cmd_by_name(cmd_name)
          response= nil
          # register notification callback
          @receive_data.on_notification {|val|
            response= val
          }
          # request information
          @send_data.send(cmd.rq)
          # wait notification (and information) to arrive
          Timeout.timeout(5) {
            waiting= true
            begin
              if !response.nil?
                response= scan_notif_response(cmd.code, response)
                waiting= response.nil?
              end
              # is_connected? should be called so that device information is updated and the callback is executed.
            end while waiting and @device.is_connected? and sleep(0.25)
          }
          # TODO do not rely on received cmd, build a new Cmd.rs instead
          #          Protocol.find_cmd_by_code(cmd_code)
          cmd.rs(response)
        rescue Timeout::Error
        end
        #------------------------------------
        private
        #------------------------------------
        def scan_notif_response(code, response)
          ary= response.scan(/../)
          rs= ary.collect {|hex| hex.to_i(16)}
          expected_cmd= rs.shift == code
          raise UnexpectedResponse, "Received #{response} response for cmd #{code}" unless expected_cmd
          rs
        end

      end
    end
  end
end
