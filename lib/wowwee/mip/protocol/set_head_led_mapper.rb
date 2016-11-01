# Mapper between developer firendly symbols and protocol codes.
#
module Wowwee
  module Mip
    module Protocol
      class SetHeadLedMapper
        OFF= 0
        ON= 1
        BLINK_SLOW= 2
        BLINK_FAST= 3
        def self.sym_to_ary(l1, l2, l3, l4)
          l1= map(l1)
          l2= map(l2)
          l3= map(l3)
          l4= map(l4)
          [l1, l2, l3, l4]
        end
        #-------------------------------------
        private
        #-------------------------------------
        def self.map(sym)
          case sym
          when :on then ON
          when :off then OFF
          when :bslow then BLINK_SLOW
          when :bfast then BLINK_FAST
          end
        end

      end
    end
  end
end
