require_relative '../protocol'
module Wowwee
  module Mip
    module Protocol

      cmd 0x14, :software_version,
        postprocessor: ->(bytes) { bytes.join('.') }
      cmd 0x19, :hardware_version,
        postprocessor: ->(bytes) { bytes.join('.') }
      require_relative 'mip_status'
      cmd 0x79, :mip_status,
        postprocessor: ->(bytes) { MipStatus.new(bytes) }
      cmd 0x82,:game_mode,
        postprocessor: ->(bytes) {
        case bytes.first
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
      }
      cmd 0x76, :set_game_mode,
        preprocessor: ->(mode) {
        case mode
        when :app       then 0x01
        when :cage      then 0x02
        when :tracking  then 0x03
        when :dance     then 0x04
        when :default   then 0x05
        when :stack     then 0x06
        when :trick     then 0x07
        when :roam      then 0x08
        end
      }
      cmd 0x08, :set_mip_position,
        preprocessor: ->(position) {
        case position
        when :on_back then [0x00]
        when :face_down then [0x01]
        end
      }
      cmd 0x70, :distance_drive,
        preprocessor: ->(data) {
        turn_angle= data[:turn_angle]
        angle_hb= turn_angle / 0x100
        angle_lb= turn_angle % 0x100
        data= [
          data[:fwd_bkw] == :fwd ? 0 : 1,
          data[:distance_cm],
          data[:turn_direction] == :clockwise ? 1 : 0,
          angle_hb, angle_lb
        ]
      }
      cmd 0x77, :stop
      cmd 0x71, :drive_forward
      cmd 0x72, :drive_backward
      cmd 0x84, :set_chest_led
      require_relative 'chest_led_status'
      cmd 0x83, :chest_led_status,
        postprocessor: ->(bytes) { ChestLedStatus.new(*bytes) }
      cmd 0x89, :flash_chest_led
      require_relative 'set_head_led_mapper'
      cmd 0x8A, :set_head_led,
        preprocessor: ->(symbols) { SetHeadLedMapper.sym_to_ary(*symbols)}
      cmd 0x06, :play_sound
      cmd 0x15, :set_volume
      cmd 0x16, :get_volume,
        postprocessor: ->(bytes) {
        bytes.first.to_i
      }
      cmd 0x0D, :radar_mode,
        postprocessor: ->(bytes) {
        case bytes.first.to_i
        when 0x00 then :disabled
        when 0x02 then :gesture
        when 0x04 then :radar
        else
          raise "Unknown radar mode: #{bytes}"
        end
      }
      cmd 0x0C, :read_radar,
        preprocessor: ->(data) { [0x04] },
        postprocessor: ->(bytes) {
        bytes.first.to_i
      }
      cmd 0x0C, :set_radar_mode,
        preprocessor: ->(new_mode) {
        byte= case new_mode
        when :disabled then 0x00
        when :gesture  then 0x02
        when :radar    then 0x04
        end
        [byte]
      }
      cmd 0x86, :reset_odometer
      cmd 0x85,  :read_odometer,
        postprocessor: ->(bytes) { Protocol::OdoCalc.bendian_to_cm(bytes) }
    end
  end
end
