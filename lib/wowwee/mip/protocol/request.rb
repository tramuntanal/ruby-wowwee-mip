module Wowwee
  module Mip
    module Protocol
      class Rq
        attr_reader :code
        def initialize(code, data=nil)
          @code= code
          @data= data
        end
        def to_a
          a= [@code]
          a= a + @data if @data
          a
        end
        def to_s
          bytes= to_a.pack('C*')
          bytes
        end
      end

    end
  end
end
