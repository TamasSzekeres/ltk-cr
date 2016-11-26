require "../spec_helper"
require "../../src/ltk-cr/base/point"

include Ltk

describe Ltk do
  describe Point do
    describe "initialize" do
      it "sets properties" do
        a = Point.new 1, 2
        b = uninitialized Point
        b.x = 1
        b.y = 2

        a.should eq b
      end

      it "should copy" do
        a = Point.new 1, 2
        b = a
        a.should eq b
      end
    end

    describe "manhattan_length" do
      it "calc manhattan length" do
        p = Point.new 1, -2
        p.manhattan_length.should eq 3
      end
    end

    describe "is_null?" do
      it "should be null" do
        p = Point.new 0, 0
        p.is_null?.should be_true
      end

      it "should not be null" do
        p = Point.new 0, 1
        p.is_null?.should be_false
      end
    end

    describe "+" do
      it "adds two points" do
        a = Point.new 1, 2
        b = Point.new 3, 4
        c = a + b
        a.x.should eq 1
        a.y.should eq 2
        b.x.should eq 3
        b.y.should eq 4
        c.x.should eq 4
        c.y.should eq 6
      end

      it "adds three points" do
        a = Point.new 1, 2
        b = Point.new 3, 4
        c = Point.new 5, 6
        d = a + b + c
        d.x.should eq 9
        d.y.should eq 12
      end

      it "increases point's coordinates" do
        p = Point.new 1, 2
        p += Point.new 3, 4
        p.x.should eq 4
        p.y.should eq 6
      end
    end

    describe "-" do
      it "subtracts two points" do
        a = Point.new 1, 2
        b = Point.new 3, 4
        c = a - b
        a.x.should eq 1
        a.y.should eq 2
        b.x.should eq 3
        b.y.should eq 4
        c.x.should eq -2
        c.y.should eq -2
      end

      it "subtracts three points" do
        a = Point.new 1, 2
        b = Point.new 3, 4
        c = Point.new 5, 6
        d = a - b - c
        d.x.should eq -7
        d.y.should eq -8
      end

      it "descreases point's coordinates" do
        p = Point.new 1, 2
        p -= Point.new 3, 4
        p.x.should eq -2
        p.y.should eq -2
      end
    end

    describe "*" do
      it "multiplies point with int" do
        a = Point.new 1, 2
        b = a * 2
        a.x.should eq 1
        a.y.should eq 2
        b.x.should eq 2
        b.y.should eq 4
      end

      it "multiplies point with float" do
        a = Point.new 1, 2
        b = a * 1.4
        b.x.should eq 1.4.round.to_i
        b.y.should eq (2 * 1.4).round.to_i
      end

      it "multiplies point's coordinate" do
        p = Point.new 1, 2
        p *= 1.4
        p.x.should eq 1.4.round.to_i
        p.y.should eq (2 * 1.4).round.to_i
      end
    end

    describe "/" do
      it "divides point with float" do
        a = Point.new 10, 15
        b = a / 1.3
        b.x.should eq 8
        b.y.should eq 12
      end

      it "divides point's coordinate" do
        p = Point.new 10, 20
        p /= 1.4
        p.x.should eq 7
        p.y.should eq 14
      end
    end
  end
end
