require 'spec_helper'
describe Wowwee::Mip::Protocol::ChestLedStatus do

  RED= [255, 0, 0, false]
  before(:each) do
    @status= Wowwee::Mip::Protocol::ChestLedStatus.new(*RED)
  end

  context "When incrementing a color" do
    it "Should have 255 as top limit for each color" do
      @status.increment(:red)
      @status.increment(:green)
      expect(@status.color).to eq [255, 10, 0]
      @status.increment(:blue, 255)
      expect(@status.color).to eq [255, 10, 252]
    end
  end
  context "When decrementing a color" do
    it "Should have 0 as bottom limit when decrementing from a positive value" do
      @status.increment(:blue, 1)
      @status.decrement(:blue, 2)
      expect(@status.color).to eq [255, 0, 0]
    end
    it "Should have 0 as bottom limit when decrementing from zero" do
      @status.decrement(:red)
      @status.decrement(:green)
      @status.decrement(:blue, 2)
      expect(@status.color).to eq [245, 0, 0]
    end
  end
  describe "Flash status" do
    context "When getting flash status" do
      it "Should return false if off initialization param was empty" do
        expect(@status.flashing?).to be false
      end
      it "Should return true if off was setted to a positive value" do
        @status.flashing!(5)
        expect(@status.flashing?).to be true
      end
    end
    context "When reseting flash status" do
      it "Should not be flashing" do
        @status.flashing!
        expect(@status.flashing?).to be false
      end
    end
  end

  #-------------------------------------
  private
  #-------------------------------------
end