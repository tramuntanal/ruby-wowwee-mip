require 'spec_helper'

describe Wowwee::Mip do
  context "Sound playing" do
    it "should play a sound" do
      @mip.play_sound()
    end
    it "should modify sound volume" do
      (1..7).each do |v|
        @mip.volume(1)
      end
    end
    it "should play many sounds" do
      @mip.play_sound do
        file(1, 30)
        file(2, 25)
      end
    end
    it "should play a sound repeatedly" do
      @mip.play_sound_repeatedly {
        volume(1)
        file(32, 2)
        volume(5)
        file(32, 3)
        volume(7)
        file(100, 4)
      }
    end
    it "should stop playing current sound" do
      @mip.silence!
      @mip.play_sound do
        silence!
      end
    end
  end
end