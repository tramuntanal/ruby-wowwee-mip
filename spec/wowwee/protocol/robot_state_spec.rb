require 'spec_helper'
describe Wowwee::Mip::Protocol::RobotState do

  before(:each) do
    @state= Wowwee::Mip::Protocol::RobotState.new
  end

  context "Before observing any command" do
    it "Should return CmdValue with nil value and current time" do
      cv= @state.read(:software_version)
      expect(cv.value).to be nil
      expect(cv.time).to be < Time.now
    end
  end
  context "First command observed" do
    it "Should read observed command value" do
      bytes= expected_bytes
      @state.observe(Wowwee::Mip::Protocol::Cmd.new(1, :test), bytes)
      cv= @state.read(:test)
      expect(cv.value).to eq bytes
      expect(cv.time).to be < Time.now
    end
  end
  FOR_0_1_SECS= 0.1
  context "When waiting for a command" do
    it "Should block until the cmd is observed" do
      bytes= expected_bytes
      readed= nil
      Thread.new {
        readed= @state.read_new(:test)
      }
      sleep(FOR_0_1_SECS)
      @state.observe(Wowwee::Mip::Protocol::Cmd.new(1, :test), bytes)
      sleep(FOR_0_1_SECS)
      expect(readed.value).to be bytes
    end
  end

  #-------------------------------------
  private
  #-------------------------------------
  def expected_bytes
    bytes= 'DEADCAFE'
    size = rand()
    bytes[0..size].to_i(16)
  end
end