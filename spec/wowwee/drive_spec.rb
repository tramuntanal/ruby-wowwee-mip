require 'spec_helper'

describe Wowwee::Mip do

  context "Robot drive" do
    it "should drive FW" do
      MIP.drive_forward(speed: 10, times: 200)
      sleep(1)
    end
    it "should drive BK 1sec" do
      MIP.drive_back(speed:10, times: 200)
      sleep(1)
    end
    it "should turn left 4 winds" do
      #      MIP.turn_left_angle()
    end
    it "should turn right 4 winds" do
    end
    it "should stop on cmd even when drive cmd was requested" do
    end
    it "should drive some distance in linear and angular directions" do
      MIP.distance_drive(distance_cm: 100, turn_angle: 90)
      sleep(3)
      MIP.stop
    end
  end

end