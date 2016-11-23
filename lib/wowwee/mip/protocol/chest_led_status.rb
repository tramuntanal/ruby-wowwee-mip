module Wowwee
  module Mip
    module Protocol
      # @return [Array] r,g,b,time_on, time_off
      # time_on: if flashing then, TIME ON in 20ms intervals (0~255) else Fade in time in 10ms intervals (0~255)
      # time_off: if flashing then, TIME OFF in 20ms intervals (0~255) else will only be 4 bytes
      class ChestLedStatus
        module Colors
          MAX_VAL_RG= 255
          MAX_VAL_B=  252
          MIN_VAL= 0
          # Max returned value for blue is 252
          WHITE= [255,  255, 252]
          BLACK= [0, 0, 0]
          RED= [255, 0, 0]
          GREEN= [0, 255, 0]
          BLUE= [0, 0, 252]
          YELLOW= [255, 255, 0]

          def max_val(color)
            case color
            when :blue  then MAX_VAL_B
            else  MAX_VAL_RG
            end
          end
        end
        include Colors

        attr_reader :color
        attr_reader :on
        attr_reader :off
        def initialize(r,g,b,on,off=nil)
          @color= [r,g,b]
          @on= on
          @off= off
        end
        def flashing?
          !@off.nil? && @off > 0
        end
        def flashing!(on=nil, off=nil)
          @on= on
          @off= off||@on
        end

        # @param color_name [sym] :red, :green or :blue
        # @param increment  [Integer] defaults to 10
        def increment(color_name, increment=10)
          c= @color[color_to_idx(color_name)]
          result= c + increment
          c= result >= max_val(color_name) ? max_val(color_name) : result
          @color[color_to_idx(color_name)]= c
        end
        # @param color_name [sym] :red, :green or :blue
        # @param decrement  [Integer] defaults to 10
        def decrement(color_name, decrement=10)
          c= @color[color_to_idx(color_name)]
          result= c - decrement
          c= result <= Colors::MIN_VAL ? Colors::MIN_VAL : result
          @color[color_to_idx(color_name)]= c
        end

        #-----------------------------
        private
        #-----------------------------

        def color_to_idx(name)
          case name
          when :red then 0
          when :green then 1
          when :blue then 2
          end
        end

      end
    end
  end
end
