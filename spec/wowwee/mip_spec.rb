require 'spec_helper'

describe Wowwee::Mip do
  it 'has a version number' do
    expect(Wowwee::Mip::VERSION).not_to be nil
  end

  context "With a MiP" do

    it 'A MiP robot should be instantiated' do
      expect(MIP).to_not be_nil
    end

    context "Robot version" do
      it "Sowftware version should return the version of the installed software" do
        status= MIP.software_version
        puts "Software version: #{status}"
        expect(status.split('.').size).to eq(4)
      end
      it "Hardware version should return the version of the robot's hardware" do
        status= MIP.hardware_version
        versions= status.split('.')
        expect(versions.size).to eq(2)
        voice, hard= versions
        puts "Hardware version: #{status}, [voice chip:#{voice}, hard:#{hard}]"
      end
    end

    #    context "positioning" do
    #      it "should go back and front again to completelly turn" do
    #        MIP.position_back!
        #        MIP.position_front! #face down
        #      end
    #    end

  end
end
