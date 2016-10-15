require 'spec_helper'

describe Wowwee::Mip do

  context "Robot drive" do
    it "should drive FW" do
      MIP.drive_forward(speed: 10, times: 200)
      sleep(1)
    end
    it "should drive BK again" do
      MIP.drive_back(speed:10, times: 200)
      sleep(1)
    end
    it "should stop on cmd even when drive cmd was requested" do
      MIP.drive_forward(times: 200)
      sleep(1)
      MIP.stop
    end
    it "should drive some distance in linear and angular directions" do
      MIP.distance_drive(distance_cm: 25, turn_angle: 90)
    end
  end

end