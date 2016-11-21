# A value object to encapsulate responded values.
# @attrib value [*] The value returned by the MiP.
# @attrib time  [Time] The time at which the value was received
#   by the protocol.
module Wowwee
  module Mip
    module Protocol
      class CmdValue
        attr_reader :value
        attr_reader :time

        def initialize(value=nil)
          @value= value
          @time= Time.new
        end

      end
    end
  end
end
