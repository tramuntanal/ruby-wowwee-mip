device_address_to_connect= '1C:05:B3:7D:95:74'

begin
  puts "========================"
  require_relative 'wowwee/mip'
  mip= Wowwee::mip(device_address_to_connect)

  puts "Software version: #{mip.software_version}"
  #  mip.distance_drive({
  #      forward: true, distance_cm: 10,
  #      turn_clockwise: true, turn_angle: 0
  #    })



rescue Exception => e
	puts "retrieval of dev information failed:#{e.class} #{e.message}--"
  puts e.backtrace.join("\n")
  mip.disconnect unless mip.nil?
	exit
end
