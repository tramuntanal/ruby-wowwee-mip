require_relative 'protocol'
require 'timeout'
module Wowwee
  module Mip
    #
    # A proxy for the Wowwee MiP robot.
    #
    class Robot

      def initialize device
        @device= device
        @transfer= Protocol::Transfer.new(device)
      end

      def disconnect
        @device.disconnect
      end

      def software_version
        @transfer.read_notif(:software_version)
        #        thread= @status.wait(:software_version)
        #        @transfer.send(:software_version)
        #        thread.join
        #        @status.software_version

        #        cmd= Protocol::SoftwareVersion
        #        version= read_notif(cmd.rq)
        #        cmd::Rs.new(version).deserialize
        #        version.join('.')
      end
      def hardware_version
        @transfer.read_notif(:hardware_version)
      end
      # @return [MipStatus] Current mip status
      def status
        @transfer.read_notif(:mip_status)
      end
      # @return [sym] Current mip game mode as one of the
      # following values: :app, :cage, :tracking, :dance,
      # :default, :stack, :trick, :roam
      def game_mode
        @transfer.read_notif(:game_mode)
      end
      def set_game_mode(mode)
        @transfer.send(:set_game_mode, mode)
      end
      def position_back!
        @transfer.send(:set_mip_position, :on_back)
      end
      def position_front!
        @transfer.send(:set_mip_position, :face_down)
      end

      #
      # Default values are:
      # mip.distance_drive({
      #     fwd_bkw: :fwd,
      #     distance_cm: 100,
      #     turn_direction: :clockwise,
      #     turn_angle: 0
      #   })
      # @param drive [Hash] Where _fwd_bkw_ can be 0 for forward / 1 for backward.
      #
      def distance_drive(fwd_bkw: :fwd, distance_cm: 100,  turn_direction: :clockwise, turn_angle: 0)
        @transfer.send(:set_mip_position, {fwd_bkw: fwd_bkw, distance_cm: distance_cm,  turn_direction: turn_direction, turn_angle: turn_angle})
      end
      def stop
        @transfer.send(:stop)
      end
      # @param speed [integer] Speed (0~30)
      # @param times [integer] Time in 7ms intervals (0~255)
      def drive_forward(speed: 30, times: 255)
        @transfer.send(:drive_forward, [speed, times])
      end
      # @param speed [integer] Speed (0~30)
      # @param times [integer] Time in 7ms intervals (0~255)
      def drive_back(speed: 10, times: 255)
        @transfer.send(:drive_backward, [speed, times])
      end

      # @param r [Integer] Red (0~255)
      # @param g [Integer] Green (0~255)
      # @param b [Integer] Blue (0~255)
      def set_chest_led(r, g, b)
        @transfer.send(:set_chest_led, [r, g, b])
      end
      def chest_led_status
        @transfer.read_notif(:chest_led_status)
      end
      # @param r [Integer] Red (0~255)
      # @param g [Integer] Green (0~255)
      # @param b [Integer] Blue (0~255)
      # @param time_on  [ Integer] in 20ms intervals(0~255)
      # @param time_off [ Integer] in 20ms intervals(0~255)
      #
      def flash_chest_led(r, g, b, time_on=1, time_off=1)
        @transfer.send(:flash_chest_led, [r, g, b, time_on, time_off])
      end
      # All params default to _:off_.
      # @param light1 [sym] :on, :off, :bslow, :bfast.
      # @param light2 [sym] :on, :off, :bslow, :bfast.
      # @param light3 [sym] :on, :off, :bslow, :bfast.
      # @param light4 [sym] :on, :off, :bslow, :bfast.
      def set_head_led(l1=:off, l2=:off, l3=:off, l4=:off)
        @transfer.send(:set_head_led, [l1, l2, l3, l4])
      end
      # Plays one of the sounds of the robot for 1 second
      def play_sound(sequence=[1, 30])
        @transfer.send(:play_sound, sequence)
      end
      def silence!
        @transfer.send(:play_sound, [105])
      end
      def volume(vol)
        @transfer.send(:play_sound, [vol])
      end
      # @returns current radar mode.
      def radar_mode
        @transfer.read_notif(:radar_mode)
      end
      # Higher the number bigger the danger.
      # @response [Integer] Where:
      #   1 => No object Or object disappear
      #   2 => See object in 10cm~30cm
      #   3 => See object less than 10cm
      #
      def read_radar
        @transfer.read_notif(:read_radar)
      end
      def set_radar_mode(mode)
        @transfer.send(:set_radar_mode, mode)
      end
      def reset_odometer
        @transfer.send(:reset_odometer)
      end
      def read_odometer
        @transfer.read_notif(:read_odometer)
      end
      #------------------------------------
      private
      #------------------------------------
      # Registers a callback to read cmd response,
      # then sends cmd and waits for the notification.
      # Timeouts in 5sec, in this case returns nil.
      # @param rq [? < Protocol::BaseCmd::Rq] the request to perform.
      def read_notif(rq)
        response= nil
        # register notification callback
        @receive_data.on_notification {|val|
          response= val
        }
        # request information
        @send_data.send(rq)
        # wait notification (and information) to arrive
        Timeout.timeout(5) {
          waiting= true
          begin
            if !response.nil?
              response= scan_notif_response(rq, response)
              waiting= response.nil?
            end
            # is_connected? should be called so that device information is updated and the callback is executed.
          end while waiting and @device.is_connected? and sleep(0.25)
        }
        response
      rescue Timeout::Error
      end
      def scan_notif_response(rq, response)
        ary= response.scan(/../)
        rs= ary.collect {|hex| hex.to_i(16)}
        expected_cmd= rs.shift == rq.code
        raise Protocol::UnexpectedResponse, "Received #{response} response for cmd #{rq.code}" unless expected_cmd
        rs
      end

    end
  end
end
