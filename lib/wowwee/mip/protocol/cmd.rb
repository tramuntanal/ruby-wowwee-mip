require_relative 'request'
# A command to the remote Mip.
# Commands are configured during system bootstrap using
# Protocol.cmd call, which registers command configurations to be used
# later during robot execution.
#
module Wowwee
  module Mip
    module Protocol
      attr_reader :code
      attr_reader :name

      # A Cmd encapsulates the code of the Mip command (defining
      # the context in which information is exchanged) and
      # optionally data processing behaviour.
      # Data behaviour is done thanks to a _preprocessor_ and a _postprocessor_.
      # @param code [byte] The code for the Mip command in the protocol.
      # @param name [sym] A developer friendly name for command indexation.
      # @param preprocessor [callback] A callback to be executed on request. Will receive the bytes to be send as argument, and should return the result to be passed to the BLE sub system.
      # @param postprocessor [callback] A callback to be executed on response. Will receive received bytes argument, and should return the result of processing those bytes.
      #
      class Cmd
        attr_reader :code, :name, :preprocessor, :postprocessor
        def initialize(code, name, preprocessor=nil, postprocessor=nil)
          @code= code
          @name= name
          @preprocessor= preprocessor
          @postprocessor= postprocessor
        end

        # Builds a Wowwee::Mip::Protocol::Rq object to be send to the
        # BLE subsistem.
        def rq(data=nil)
          if @preprocessor
            data= @preprocessor.call(data)
          end
          Wowwee::Mip::Protocol::Rq.new(@code, data)
        end

        # @param bytes [Array] Received bytes from BLE sub system.
        # @returns [Array|object] Returns the _bytes_, which may have been postprocessed if a _postprocessor_ was configured for this command instance.
        def rs(bytes)
          bytes= [] if bytes.nil?
          if @postprocessor
            bytes= @postprocessor.call(bytes)
          end
          bytes
        end
      end
    end
  end
end
