module Wowwee
  module Mip
    module Protocol
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
    end
  end
end
