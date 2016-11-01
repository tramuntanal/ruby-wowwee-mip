module Wowwee
  module Mip
    module Protocol
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
    end
  end
end
