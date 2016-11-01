require 'spec_helper'
require 'wowwee/mip/protocol/cmd'
describe Wowwee::Mip::Protocol::Cmd do

  context "Serialized command request" do
    it "should only contain the command code when no data is sent" do
      cmd= Wowwee::Mip::Protocol::Cmd.new(0x1, :test_code)
      expect(cmd.code).to eq 0x1
      expect(cmd.name).to eq :test_code
      expect(cmd.rq.to_s).to eq "\x01"
    end
    it "should contain command code and data when both are sent" do
      cmd= Wowwee::Mip::Protocol::Cmd.new(0x2, :test_code_data)
      data= [0x3, 0x4]
      expect(cmd.rq(data).to_s).to eq "\x02\x03\x04"
    end
  end

  context "Deserialized command response" do
    it "should contain no data if no data is received" do
      cmd= Wowwee::Mip::Protocol::Cmd.new(0x3, :no_data)
      expect(cmd.rs(nil)).to eq []
    end
    it "should contain received data when some is received" do
      cmd= Wowwee::Mip::Protocol::Cmd.new(0x3, :some_data)
      expect(cmd.rs([0xA, 0xB, 0xC, 0xD])).to eq [0xA, 0xB, 0xC, 0xD]
    end
    it "should postprocess received data when a postprocessor exists" do
      cmd= Wowwee::Mip::Protocol::Cmd.new(0x3, :postpro, nil, ->(bytes) { bytes.inject(:+) })
      expect(cmd.rs([0xA, 0xB, 0xC, 0xD])).to eq 46
    end
  end

end