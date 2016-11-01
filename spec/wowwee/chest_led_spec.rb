require 'on_robot_spec_helper'

describe Wowwee::Mip do
  describe "Chest led light" do

    # Max returned value for blue is 252
    WHITE= [255,  255, 252]
    BLACK= [0, 0, 0]
    RED= [255, 0, 0]
    GREEN= [0, 255, 0]
    BLUE= [0, 0, 252]
    YELLOW= [255, 255, 0]

    it "should light base colors: white, black, r, g, b" do
      given_the_base_colors_serie
      colors_should_light_one_after_the_other_in_the :chest
    end
    it "Senyera" do
      given_the_senyera_colors
      colors_should_light_one_after_the_other_in_the :chest
    end

    context "Flash" do
      it "should flash five times in one second" do
        MIP.flash_chest_led(*WHITE) #time on & off have default value of 1
        sleep(1)
        #          status= MIP.chest_led_status
        #          expect(status.color).to be(WHITE)
        #          expect(status.flashing?).to be(true)
        MIP.set_chest_led(*BLUE)
      end
    end

    #------------------------------------------------
    private
    #------------------------------------------------

    def given_the_base_colors_serie
      @colors= [WHITE,BLACK,RED,GREEN,BLUE,]
    end
    def given_the_senyera_colors
      @colors= [YELLOW,RED,YELLOW,RED,YELLOW,RED,YELLOW,RED,YELLOW,]
    end
    def colors_should_light_one_after_the_other_in_the(place)
      @colors.each {|color|
        MIP.send("set_#{place}_led".to_sym, *color)
        sleep 0.250
        #        "1.1.1.1"
        status= MIP.send("#{place}_led_status")
        expect(status.color).to eq(color)
        expect(status.flashing?).to be(false)
      }
    end

  end
end