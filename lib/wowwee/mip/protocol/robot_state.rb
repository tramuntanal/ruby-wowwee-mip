# Encapsulates the states of the diferent parts of the robot.
#
module Wowwee
  module Mip
    module Protocol
      class RobotState
        def initialize
          @states= Hash.new(CmdValue.new)
        end

        # As the RobotState is an observer of the NotifQueue it should implement this method.
        # @param cmd [Cmd] Command from which the value is received.
        # @param value [?] Received value.
        def observe(cmd, value)
          value= CmdValue.new(value)
          @states[cmd.name]= value
        end

        def read(cmd_name)
          @states[cmd_name]
        end

        FOR_5_SECS= 5
        FOR_0_1_SECS= 0.1
        def read_new(cmd_name, start=Time.now)
          cmd_val= @states[cmd_name]
          Timeout.timeout(FOR_5_SECS) {
            while start > cmd_val.time
              sleep(FOR_0_1_SECS)
              cmd_val= @states[cmd_name]
            end
          }
        rescue
        ensure
          return cmd_val
        end

      end
    end
  end
end
