require 'spec_helper'

describe Wowwee::Mip do

  context "Robot status" do
    it "should return the current status of the robot" do
      status= MIP.status
      expect(status.battery_level).to be > 0
      expect(status.on_back?).to be false
      expect(status.upright?).to be true
      expect(status.picked_up?).to be false
      expect(status.hand_stand?).to be false
      expect(status.face_down_on_tray?).to be false
      expect(status.on_back_with_kickstand?).to be false
    end

    it "should return default Mip mode when current game mode is requested" do
      mode= MIP.game_mode
      expect(mode).to be :app
    end
    it "should be able to change Mip game modes" do
      should_change_to_mode(:app)
      should_change_to_mode(:cage)
      should_change_to_mode(:tracking)
      should_change_to_mode(:dance)
      should_change_to_mode(:default)
      should_change_to_mode(:stack)
      should_change_to_mode(:trick)
      should_change_to_mode(:roam)
    end
    def should_change_to_mode(new_mode)
      MIP.set_game_mode new_mode
      mode= MIP.game_mode
      expect(mode).to be new_mode
    end
  end

end