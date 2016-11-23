require_relative 'wowwee/mip'
require_relative 'wowwee/mip/protocol/chest_led_status'
require_relative 'human_input_interpreter'
require 'io/console'
class RobotController
  def initialize(address= '1C:05:B3:7D:95:74')
    @mip= Wowwee::mip(address)
    @interpreter= HumanInputInterpreter.new
    print_menu
  end

  # print the menu
  def m
    print_menu
  end
  def drive
    puts_quit_msg
    puts "Move the robot with arrow keys"
    do_key_loop {|k|
      code= @interpreter.drive_key_to_code(k)
      # TODO
      #      @mip.xxx(code)
    }
    print_menu
  end

  def sounds
    puts_quit_msg
    puts "Introduce the sound number to play [1..106] or a letter:"
    do_key_loop {|k|
      code= @interpreter.sound_key_to_code(k)
      @mip.play_sound(code)
    }
    print_menu
  end

  def chest_led
    puts_quit_msg
    #SPACE         - Toggle on/off
    puts <<EOCHEST
R/r           - Increment/Decrement red color
G/g           - Increment/Decrement green color
B/b           - Increment/Decrement blue color
SPACE         - Resets to white.
RETURN        - Toggle Flash on/off
EOCHEST
    status= @mip.chest_led_status
    do_key_loop {|k|
      if k == "\r"
        if status.flashing?
          status.flashing!
          @mip.set_chest_led(*status.color)
        else
          status.flashing!(1)
          @mip.flash_chest_led(*status.color)
        end
      elsif k == ' '
        @mip.set_chest_led(*Wowwee::Mip::Protocol::ChestLedStatus::Colors::WHITE)
      else
        case k
        when 'R' then status.increment(:red)
        when 'r' then status.decrement(:red)
        when 'G' then status.increment(:green)
        when 'g' then status.decrement(:green)
        when 'B' then status.increment(:blue)
        when 'b' then status.decrement(:blue)
        end
        @mip.set_chest_led(*status.color)
      end
      status= @mip.chest_led_status
    }
    print_menu
  end

  def vol
    puts "Volume: +/- for up/down"
    volume= @mip.volume
    do_key_loop {|k|
      case k
      when '+' then volume.to_i >= 7 ? 7 : volume+= 1
      when '-' then volume.to_i <= 0 ? 0 : volume-= 1
      end
      @mip.volume= volume
    }
    print_menu
  end

  def inspect
    self.class.name
  end
  #-----------------------------------
  private
  #-----------------------------------

  def print_menu
    puts <<EOOPTS
drive         - Drive with the keyboard
chest_led     - Chest led: turn on, turn off, change color, flash...
head_led      - Head led: turn on, turn off, flash...
sounds        - Play sounds like a keyboard
vol           - Volume +/-
quit          - Exit program
EOOPTS
  end
  def puts_quit_msg
    puts "Use 'q' to quit"
  end
  def do_key_loop(&proc)
    exit= false
    STDIN.echo = false
    STDIN.raw!
    while !exit
      key= STDIN.getc.chr
      if key == "\e" then
        key << STDIN.read_nonblock(3) rescue nil
        key << STDIN.read_nonblock(2) rescue nil
      end
      if key == 'q'
        exit= true
      else
        proc.call(key)
      end
    end
  ensure
    STDIN.echo = true
    STDIN.cooked!
  end
end
