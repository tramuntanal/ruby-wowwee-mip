require 'spec_helper'

describe Wowwee::Mip do
  context "Sound playing" do
    it "should play a sound" do
      MIP.play_sound
      sleep(1)
    end
    it "should modify sound volume" do
      (0..7).each do |vol|
        MIP.volume(vol)
        sleep(1)
      end
    end
    it "should play many sounds for 300ms each" do
      (1..104).each_slice(8) { |files|
        file_delays= files.collect {|f| [f, 10]}
        MIP.play_sound(file_delays.flatten)
        sleep(8*0.300)
      }
    end
    it "should stop playing current sound" do
      MIP.play_sound
      MIP.silence!
    end
  end
end