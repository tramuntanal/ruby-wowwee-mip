require 'spec_helper'
require 'human_input_interpreter'
describe HumanInputInterpreter do

  before(:each) do
    @interpreter= HumanInputInterpreter.new
  end

  describe "Sound Menu - translate key inputs to sound codes" do
    context "when input is a number" do
      it "should convert the number to Integer" do
        expect(@interpreter.sound_key_to_code('1')).to eq 1
        expect(@interpreter.sound_key_to_code('100')).to eq 100
        expect(@interpreter.sound_key_to_code('45')).to eq 45
        expect(@interpreter.sound_key_to_code('106')).to eq 106
      end
      it "should raise ArgumentError when input is negative or zero" do
        expect { @interpreter.sound_key_to_code('-1')}.to raise_error(ArgumentError)
        expect { @interpreter.sound_key_to_code('0')}.to raise_error(ArgumentError)
        expect { @interpreter.sound_key_to_code('0000')}.to raise_error(ArgumentError)
        expect { @interpreter.sound_key_to_code('0.0')}.to raise_error(ArgumentError)
      end
      it "should raise ArgumentError when input is bigger than 106f" do
        expect { @interpreter.sound_key_to_code('107')}.to raise_error(ArgumentError)
      end
    end
    context "When input is not a letter nor a number" do
      it "should raise ArgumentError" do
        expect { @interpreter.sound_key_to_code("\t")}.to raise_error(ArgumentError)
      end
    end
    context "When input is a letter" do
      it "should convert a to z in 1 to 25" do
        expect(@interpreter.sound_key_to_code('a')).to eq 1
        expect(@interpreter.sound_key_to_code('b')).to eq 2
        expect(@interpreter.sound_key_to_code('z')).to eq 26
      end
      it "should convert A to Z in 27 to 52" do
        expect(@interpreter.sound_key_to_code('A')).to eq 27
        expect(@interpreter.sound_key_to_code('D')).to eq 30
        expect(@interpreter.sound_key_to_code('Z')).to eq 52
      end
    end
  end

  describe "Drive Menu - translate key input to drive orders" do
    context "When input is not an arrow" do
      it "should return nil" do
        expect(@interpreter.drive_key_to_code('a')).to be nil
      end
    end
    context "When input is an arrow" do
      it "should return :fwd when input is up arrow" do
        expect(@interpreter.drive_key_to_code("\e[A")).to be :fwd
      end
      it "should return :back when input is down arrow" do
        expect(@interpreter.drive_key_to_code("\e[B")).to be :back
      end
      it "should return :right when input is right arrow" do
        expect(@interpreter.drive_key_to_code("\e[C")).to be :right
      end
      it "should return :left when input is left arrow" do
        expect(@interpreter.drive_key_to_code("\e[D")).to be :left
      end
    end
  end

end