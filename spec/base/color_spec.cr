require "../spec_helper"
require "../../src/ltk/base/color"

include Ltk

describe Ltk do
  describe Color do
    describe "initialize" do
      it "sets properties" do
        a = Color.new 0x00, 0x80, 0xa0, 0xff
        b = uninitialized Color
        b.red = 0x00_u8
        b.green = 0x80_u8
        b.blue = 0xa0_u8
        b.alpha = 0xff_u8

        a.should eq b
      end

      it "sets properties from Rgb" do
        c = Color.new 0xff123456_u32
        c.red.should eq 0x12_u8
        c.green.should eq 0x34_u8
        c.blue.should eq 0x56_u8
        c.alpha.should eq 0xff_u8
      end
    end
  end
end
