require 'on_robot_spec_helper'

describe Wowwee::Mip do

  context "Robot radar" do
    it "should obtain radar mode" do
      mode= MIP.radar_mode
      [:disabled, :gesture, :radar].include? mode
    end
    it "should be able to set radar mode" do
      MIP.set_radar_mode(:radar)
      expect(MIP.radar_mode).to eq :radar
    end
    it "should return no_object when it has no obstacle in front" do
      MIP.set_radar_mode(:radar)
      peril= MIP.read_radar
      expect(peril).to eq 1
    end
  end
end