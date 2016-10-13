require 'spec_helper'

describe Wowwee::Mip do
  describe "Head led lights" do

    context "Head led" do
      it "should light one led after the other" do
        seq= [
          [:on ,:off, :off, :off],
          [:off, :on, :off, :off],
          [:off, :off, :on, :off],
          [:off, :off, :off, :on],
        ]
        seq.each {|status|
          MIP.set_head_led(*status)
          sleep(0.250)
        }
        MIP.set_head_led(:off, :off, :off, :off)
      end
      context "All leds toghether" do
        it "should blink slowly" do
          MIP.set_head_led(:bslow, :bslow, :bslow, :bslow)
          sleep(5)
          MIP.set_head_led(:off, :off, :off, :off)
        end
        it "should blink quickly" do
          MIP.set_head_led(:bfast, :bfast, :bfast, :bfast)
          sleep(5)
          MIP.set_head_led(:off, :off, :off, :off)
        end
      end
    end

  end
end