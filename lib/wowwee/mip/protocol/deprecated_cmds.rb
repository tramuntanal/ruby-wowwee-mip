module Cmd # TODO eliminar aquest mòdul!
  class GameMode < Base
    CMD=     0x82
    def initialize; super(CMD); end
  end
  class SetGameMode < Base
    CMD=     0x76
    def initialize(mode)
      super(CMD, [mode])
    end
  end
  class SetMipPosition < Base
    CMD=     0x08
    def initialize(position)
      super(CMD)
      @data= case position
      when :on_back then [0x00]
      when :face_down then [0x01]
      end
    end
  end
  class SetChestLed < Base
    CMD= 0x84
    def initialize(r,g,b)
      super(CMD, [r,g,b])
    end
  end
  class GetChestLed < Base
    CMD=     0x83
    def initialize; super(CMD); end
  end
  class FlashChestLed < Base
    CMD= 0x89
    def initialize(r,g,b, time_on, time_off)
      super(CMD, [r,g,b, time_on, time_off])
    end
  end
  class SetHeadLed < Base
    CMD= 0x8A
    OFF= 0
    ON= 1
    BLINK_SLOW= 2
    BLINK_FAST= 3
    def initialize(l1, l2, l3, l4)
      l1= map(l1)
      l2= map(l2)
      l3= map(l3)
      l4= map(l4)
      super(CMD, [l1, l2, l3, l4])
    end
    private
    def map(sym)
      case sym
      when :on then ON
      when :off then OFF
      when :bslow then BLINK_SLOW
      when :bfast then BLINK_FAST
      end
    end
  end
  class GetHeadLed < Base
    CMD=     0x8B
    def initialize; super(CMD); end
  end

  class Stop < Base
    CMD= 0x77
    def initialize; super(CMD) end
  end
  class DriveForward < Base
    CMD= 0x71
    def initialize(speed, times)
      super(CMD, [speed, times])
    end
  end
  class DriveBackward < Base
    CMD= 0x72
    def initialize(speed, times)
      super(CMD, [speed, times])
    end
  end
  class DistanceDrive < Base
    CMD= 0x70
    def initialize(data)
      super(CMD, data)
    end
  end
  class PlaySound < Base
    CMD= 0x06
    def initialize(data)
      super(CMD, data)
    end
  end
  class Volume < Base
    CMD= 0x15
    def initialize(data)
      super(CMD, [data])
    end
  end
  class ResetOdometer < Base
    CMD= 0x86
    def initialize; super(CMD); end
  end
  class ReadOdometer < Base
    CMD= 0x85
    def initialize; super(CMD); end
  end
  class ReadRadar < Base
    CMD= 0x0C
    def initialize; super(CMD, [0x04]); end
  end
  class RadarMode < Base
    CMD= 0x0D
    def initialize; super(CMD); end
  end
  class SetRadarMode < Base
    CMD= 0x0C
    def initialize(new_mode)
      byte= case new_mode
      when :disabled then 0x00
      when :gesture  then 0x02
      when :radar    then 0x04
      end
      super(CMD, [byte])
    end
  end
end