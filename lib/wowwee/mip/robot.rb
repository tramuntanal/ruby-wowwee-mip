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
        @protocol= Protocol::Ble.new(@device)
      end

      def disconnect
        @device.disconnect
      end

      def software_version
        @protocol.read(:software_version)
      end
      def hardware_version
        @protocol.read(:hardware_version)
      end
      # @return [MipStatus] Current mip status
      def status
        @protocol.read(:mip_status)
      end
      # @return [sym] Current mip game mode as one of the
      # following values: :app, :cage, :tracking, :dance,
      # :default, :stack, :trick, :roam
      def game_mode
        @protocol.read(:game_mode)
      end
      def set_game_mode(mode)
        @protocol.send(:set_game_mode, mode)
      end
      def position_back!
        @protocol.send(:set_mip_position, :on_back)
      end
      def position_front!
        @protocol.send(:set_mip_position, :face_down)
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
        @protocol.send(:set_mip_position, {fwd_bkw: fwd_bkw, distance_cm: distance_cm,  turn_direction: turn_direction, turn_angle: turn_angle})
      end
      def stop
        @protocol.send(:stop)
      end
      # @param speed [integer] Speed (0~30)
      # @param times [integer] Time in 7ms intervals (0~255)
      def drive_forward(speed: 30, times: 255)
        @protocol.send(:drive_forward, [speed, times])
      end
      # @param speed [integer] Speed (0~30)
      # @param times [integer] Time in 7ms intervals (0~255)
      def drive_back(speed: 10, times: 255)
        @protocol.send(:drive_backward, [speed, times])
      end

      # @param r [Integer] Red (0~255)
      # @param g [Integer] Green (0~255)
      # @param b [Integer] Blue (0~255)
      def set_chest_led(r, g, b)
        @protocol.send(:set_chest_led, [r, g, b])
      end
      def chest_led_status
        @protocol.read(:chest_led_status)
      end
      # @param r [Integer] Red (0~255)
      # @param g [Integer] Green (0~255)
      # @param b [Integer] Blue (0~255)
      # @param time_on  [ Integer] in 20ms intervals(0~255)
      # @param time_off [ Integer] in 20ms intervals(0~255)
      #
      def flash_chest_led(r, g, b, time_on=1, time_off=1)
        @protocol.send(:flash_chest_led, [r, g, b, time_on, time_off])
      end
      # All params default to _:off_.
      # @param light1 [sym] :on, :off, :bslow, :bfast.
      # @param light2 [sym] :on, :off, :bslow, :bfast.
      # @param light3 [sym] :on, :off, :bslow, :bfast.
      # @param light4 [sym] :on, :off, :bslow, :bfast.
      def set_head_led(l1=:off, l2=:off, l3=:off, l4=:off)
        @protocol.send(:set_head_led, [l1, l2, l3, l4])
      end
      # Plays one of the sounds of the robot for 1 second
      def play_sound(sequence=[1, 30])
        @protocol.send(:play_sound, sequence)
      end
      def silence!
        @protocol.send(:play_sound, [105])
      end
      def volume(vol)
        @protocol.send(:play_sound, [vol])
      end
      # @returns current radar mode.
      def radar_mode
        @protocol.read(:radar_mode)
      end
      # Higher the number bigger the danger.
      # @response [Integer] Where:
      #   1 => No object Or object disappear
      #   2 => See object in 10cm~30cm
      #   3 => See object less than 10cm
      #
      def read_radar
        @protocol.read(:read_radar)
      end
      def set_radar_mode(mode)
        @protocol.send(:set_radar_mode, mode)
      end
      def reset_odometer
        @protocol.send(:reset_odometer)
      end
      def read_odometer
        @protocol.read(:read_odometer)
      end

    end
  end
end
