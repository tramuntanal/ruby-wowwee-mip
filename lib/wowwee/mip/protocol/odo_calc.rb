module Wowwee
  module Mip
    module Protocol
      module OdoCalc

        WHEEL_RADIUS= 48.5
        # Takes an array of 4 bytes representing the distance
        # and converts them to cm
        # @param [bytes] 4 bytes in big endian, most significant byte is at top right.
        # @return [double] distance in centimeters.
        def self.bendian_to_cm( bytes )
          rads= bytes.pack('C*').unpack('N').first
          rads / WHEEL_RADIUS
        end
      end
    end
  end
end
