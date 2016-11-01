require 'spec_helper'

describe Wowwee::Mip do

  context "Robot odometer" do
    context "big endian calculator" do
      it "should compute 0rad as 0cm" do
        expect(Wowwee::Mip::Protocol::OdoCalc.bendian_to_cm([0x0,0x0,0x0,0x0])).to eq 0
      end
      it "should compute 1rad as 0.02cm" do
        expect(Wowwee::Mip::Protocol::OdoCalc.bendian_to_cm([0x0,0x0,0x0,0x1]).round(2)).to eq 0.02
      end
      it "should compute 48rad as 0,99cm" do
        expect(Wowwee::Mip::Protocol::OdoCalc.bendian_to_cm([0,0,0,0x30]).round(2)).to eq 0.99#cm
      end
      it "should compute 2989744rad as 61644.20618556701cm" do
        expect(Wowwee::Mip::Protocol::OdoCalc.bendian_to_cm([0, 45, 158, 176])).to eq 61644.20618556701#cm
      end
      it "should compute 286331153rad as 5903735.113402062cm" do
        expect(Wowwee::Mip::Protocol::OdoCalc.bendian_to_cm([0x11,0x11,0x11,0x11])).to eq 5903735.113402062#cm
      end

    end
    it "should reset on demand" do
      MIP.reset_odometer
      final= MIP.read_odometer
      expect(final).to be < 2
    end
    it "should increment when robot goes forward" do
      initial= MIP.read_odometer
      MIP.drive_forward(speed: 20, times: 150)
      sleep(1)
      final= MIP.read_odometer
      expect(initial).to be < final
      expect(final).to be < 100#cm
    end
    it "should increment when robot goes backward" do
      initial= MIP.read_odometer
      MIP.drive_back(speed: 20, times: 150)
      sleep(1)
      final= MIP.read_odometer
      expect(initial).to be < final
    end

  end
end