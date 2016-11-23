device_address_to_connect= '1C:05:B3:7D:95:74'

#->>>>>>>>>>>>> Using lowlevel ruby
#require 'io/console'
## Reads keypresses from the user including 2 and 3 escape character sequences.
#def read_char
#  STDIN.echo = false
#  STDIN.raw!
#
#  input = STDIN.getc.chr
#  if input == "\e" then
#    input << STDIN.read_nonblock(3) rescue nil
#    input << STDIN.read_nonblock(2) rescue nil
#  end
#ensure
#  STDIN.echo = true
#  STDIN.cooked!
#
#  return input
#end
#def show_single_key
#  c = read_char
#
#  case c
#  when " "
#    puts "SPACE"
#  when "\t"
#    puts "TAB"
#  when "\r"
#    puts "RETURN"
#  when "\n"
#    puts "LINE FEED"
#  when "\e"
#    puts "ESCAPE"
#  when "\e[A"
#    puts "UP ARROW"
#  when "\e[B"
#    puts "DOWN ARROW"
#  when "\e[C"
#    puts "RIGHT ARROW"
#  when "\e[D"
#    puts "LEFT ARROW"
#  when "\177"
#    puts "BACKSPACE"
#  when "\004"
#    puts "DELETE"
#  when "\e[3~"
#    puts "ALTERNATE DELETE"
#  when "\u0003"
#    puts "CONTROL-C"
#    exit 0
#  when /^.$/
#    puts "SINGLE CHAR HIT: #{c.inspect}"
#  else
#    puts "SOMETHING ELSE: #{c.inspect}"
#  end
#end
#def control_robot_by_kbd
#  show_single_key while(true)
#end

#->>>>>>>>>>>>> Using remedy gem
#require 'remedy'
#def control_robot_by_kbd(mip)
#  puts "inn"
#  include Remedy
#  user_input = Interaction.new
#
#  user_input.loop do |key|
#    puts key
#    #    case key
#    #    when 's'
#    puts "software version: #{mip.software_version}"
#      #    end
#  end
#end



begin

  puts "========================"
  require_relative 'wowwee/mip'
  mip= Wowwee::mip(device_address_to_connect)
  control_robot_by_kbd(mip)
  exit

  #  puts "Software version: #{mip.software_version}"
  loop {
    #
    #   if robot.has_obstacle?
    #     if robot.search_freeway
    #       robot.drive_forward
    #     end
    #   else
    #     robot.drive_forward
    #   end
    #
  }
  # register once for notifications
  require_relative 'wowwee/mip/protocol'
  mip.set_radar_mode(:radar)
  @send_data= mip.send_data
  @receive_data= mip.receive_data
  @receive_data.on_notification {|val|
    puts "RECEIVED: [#{val}]!!!!!!!!!!!!!"
  }
  # check if robot sends notifications without having to request and callback is invoked on every notification
  mip.drive_forward(speed: 25, times: 150)
  require 'timeout'
  Timeout.timeout(5) {
    loop {
      rs=  mip.read_notif(Wowwee::Mip::Protocol::Cmd::SetRadarMode.new(:radar))
      puts "RADAR: #{rs}"
    }
  }
  #    sleep 5
rescue Exception => e
  puts "retrieval of dev information failed:#{e.class} #{e.message}--"
  puts e.backtrace.join("\n")
  mip.disconnect unless mip.nil?
  exit
end