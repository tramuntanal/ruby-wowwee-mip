require_relative 'protocol'
require 'timeout'
module Wowwee
  module Mip
    #
    # A proxy for the Wowwee MiP robot.
    #
    class Robot

      class UnexpectedResponse < Exception; end

      def initialize device
        @device= device
        @send_data= Protocol::SendDataService.new(device)
        @receive_data= Protocol::ReceiveDataService.new(device)
      end

      def disconnect
        @device.disconnect
      end

      def software_version
        version= read_notif(Protocol::Cmd::SoftwareVersion.new)
        version.join('.')
      end
      def hardware_version
        version= read_notif(Protocol::Cmd::HardwareVersion.new)
        version.join('.')
      end
      class MipStatus
        def initialize(rs)
          @rs= rs
        end
        def battery_level
          #Battery Level :0x4D(4.0V)-0x7C(6.4V)
          @rs[0] - 0x4D
        end
        def on_back?
          @rs[1] == 0x00
        end
        def face_down?
          @rs[1] == 0x01
        end
        def upright?
          @rs[1] == 0x02
        end
        def picked_up?
          @rs[1] == 0x03
        end
        def hand_stand?
          @rs[1] == 0x04
        end
        def face_down_on_tray?
          @rs[1] == 0x05
        end
        def on_back_with_kickstand?
          @rs[1] == 0x06
        end
      end
      # @return [MipStatus] Current mip status
      def status
        rs= read_notif(Protocol::Cmd::MipStatus.new)
        MipStatus.new(rs)
      end
      # @return [sym] Current mip game mode as one of the
      # following values: :app, :cage, :tracking, :dance,
      # :default, :stack, :trick, :roam
      def game_mode
        retries||= 1
        rs= read_notif(Protocol::Cmd::GameMode.new)
        case rs.first
        when 0x01 then :app
        when 0x02 then :cage
        when 0x03 then :tracking
        when 0x04 then :dance
        when 0x05 then :default
        when 0x06 then :stack
        when 0x07 then :trick
        when 0x08 then :roam
        else raise "Unknown game mode #{rs}-#{rs.class}"
        end
      rescue
        retries+=1
        retry if retries < 2
      end
      def set_game_mode(mode)
        val= case mode
        when :app       then 0x01
        when :cage      then 0x02
        when :tracking  then 0x03
        when :dance     then 0x04
        when :default   then 0x05
        when :stack     then 0x06
        when :trick     then 0x07
        when :roam      then 0x08
        end
        @send_data.send(Protocol::Cmd::SetGameMode.new(val))
      end
      def position_back!
        @send_data.send(Protocol::Cmd::SetMipPosition.new(:on_back))
      end
      def position_front!
        @send_data.send(Protocol::Cmd::SetMipPosition.new(:face_down))
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
        angle_hb= turn_angle / 0x100
        angle_lb= turn_angle % 0x100
        data= [
          fwd_bkw == :fwd ? 0 : 1,
          distance_cm,
          turn_direction == :clockwise ? 1 : 0,
          angle_hb, angle_lb
        ]
        @send_data.send(Protocol::Cmd::DistanceDrive.new(data))
      end
      def stop
        @send_data.send(Protocol::Cmd::Stop.new)
      end
      # @param speed [integer] Speed (0~30)
      # @param times [integer] Time in 7ms intervals (0~255)
      def drive_forward(speed: 30, times: 255)
        @send_data.send(Protocol::Cmd::DriveForward.new(speed, times))
      end
      # @param speed [integer] Speed (0~30)
      # @param times [integer] Time in 7ms intervals (0~255)
      def drive_back(speed: 10, times: 255)
        @send_data.send(Protocol::Cmd::DriveBackward.new(speed, times))
      end

      # @param r [Integer] Red (0~255)
      # @param g [Integer] Green (0~255)
      # @param b [Integer] Blue (0~255)
      def set_chest_led(r, g, b)
        @send_data.send(Protocol::Cmd::SetChestLed.new(r, g, b))
      end
      # @return [Array] r,g,b,time_on, time_off
      # time_on: if flashing then, TIME ON in 20ms intervals (0~255) else Fade in time in 10ms intervals (0~255)
      # time_off: if flashing then, TIME OFF in 20ms intervals (0~255) else will only be 4 bytes
      class ChestLedStatus
        attr_reader :color
        def initialize(r,g,b,on,off=nil)
          @color= [r,g,b]
          @on= on
          @off= off
        end
        def flashing?
          !@off.nil? && @off > 0
        end
      end
      def chest_led_status
        rs= read_notif(Protocol::Cmd::GetChestLed.new)
        ChestLedStatus.new(*rs)
      end
      # @param r [Integer] Red (0~255)
      # @param g [Integer] Green (0~255)
      # @param b [Integer] Blue (0~255)
      # @param time_on  [ Integer] in 20ms intervals(0~255)
      # @param time_off [ Integer] in 20ms intervals(0~255)
      #
      def flash_chest_led(r, g, b, time_on=1, time_off=1)
        @send_data.send(Protocol::Cmd::FlashChestLed.new(r, g, b, time_on, time_off))
      end
      # All params default to _:off_.
      # @param light1 [sym] :on, :off, :bslow, :bfast.
      # @param light2 [sym] :on, :off, :bslow, :bfast.
      # @param light3 [sym] :on, :off, :bslow, :bfast.
      # @param light4 [sym] :on, :off, :bslow, :bfast.
      def set_head_led(l1=:off, l2=:off, l3=:off, l4=:off)
        @send_data.send(Protocol::Cmd::SetHeadLed.new(l1, l2, l3, l4))
      end
      #------------------------------------
      private
      #------------------------------------

      def read_notif(cmd)
        response= nil
        # register notification callback
        @receive_data.on_notification {|val|
          response= val
        }
        # request information
        @send_data.send(cmd)
        # wait notification (and information) to arrive
        Timeout.timeout(5) {
          waiting= true
          begin
            if !response.nil?
              response= scan_notif_response(cmd, response)
              waiting= response.nil?
            end
            # is_connected? should be called so that device information is updated and the callback is executed.
          end while waiting and @device.is_connected? and sleep(0.25)
        }
        response
      rescue Timeout::Error
      end
      def scan_notif_response(cmd, response)
        ary= response.scan(/../)
        rs= ary.collect {|hex| hex.to_i(16)}
        # do not raise exception, keep waiting
        expected_cmd= rs.shift == cmd.class::CMD
        #raise UnexpectedResponse, "Received #{response} response for cmd #{cmd.class::CMD}" unless expected_cmd
        rs
      end

    end
  end
end
