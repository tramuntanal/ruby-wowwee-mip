require_relative 'protocol/cmd'
module Wowwee
  module Mip
    #
    # Good explanation of ATT and GATT concepts: https://epxx.co/artigos/bluetooth_gatt.html
    #
    module Protocol

      class UnexpectedResponse < Exception; end

      CMDS_BY_CODE= {}
      CMDS_BY_NAME= {}

      def self.cmd(code, name, preprocessor: nil, postprocessor: nil)
        cmd= Cmd.new(code, name, preprocessor, postprocessor)
        CMDS_BY_CODE[code]= cmd
        CMDS_BY_NAME[name]= cmd
      end
      def self.find_cmd_by_name(cmd_name)
        CMDS_BY_NAME[cmd_name]
      end
      def self.find_cmd_by_code(code)
        CMDS_BY_CODE[code]
      end

    end
  end
end
require_relative 'protocol/transfer'
require_relative 'protocol/odo_calc'
