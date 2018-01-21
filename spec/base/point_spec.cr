require "../spec_helper"
require "../../src/ltk/base/point"

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

  describe PointF do
    describe "initialize" do
      it "sets properties" do
        a = PointF.new 1.0, 2.0
        b = uninitialized PointF
        b.x = 1.0
        b.y = 2.0

        a.should eq b
      end

      it "should copy" do
        a = PointF.new 1.0, 2.0
        b = a
        a.should eq b
      end
    end

    describe "manhattan_length" do
      it "calc manhattan length" do
        p = PointF.new 1.0, -2.0
        p.manhattan_length.should eq 3.0
      end
    end

    describe "is_null?" do
      it "should be null" do
        p = PointF.new 0.0, 0.0
        p.is_null?.should be_true
      end

      it "should not be null" do
        p = PointF.new 0.0, 1.0
        p.is_null?.should be_false
      end
    end

    describe "+" do
      it "adds two points" do
        a = PointF.new 1.0, 2.0
        b = PointF.new 3.0, 4.0
        c = a + b
        a.x.should eq 1.0
        a.y.should eq 2.0
        b.x.should eq 3.0
        b.y.should eq 4.0
        c.x.should eq 4.0
        c.y.should eq 6.0
      end

      it "adds three points" do
        a = PointF.new 1.0, 2.0
        b = PointF.new 3.0, 4.0
        c = PointF.new 5.0, 6.0
        d = a + b + c
        d.x.should eq 9.0
        d.y.should eq 12.0
      end

      it "increases point's coordinates" do
        p = PointF.new 1.0, 2.0
        p += PointF.new 3.0, 4.0
        p.x.should eq 4.0
        p.y.should eq 6.0
      end
    end

    describe "-" do
      it "subtracts two points" do
        a = PointF.new 1.0, 2.0
        b = PointF.new 3.0, 4.0
        c = a - b
        a.x.should eq 1.0
        a.y.should eq 2.0
        b.x.should eq 3.0
        b.y.should eq 4.0
        c.x.should eq -2.0
        c.y.should eq -2.0
      end

      it "subtracts three points" do
        a = PointF.new 1.0, 2.0
        b = PointF.new 3.0, 4.0
        c = PointF.new 5.0, 6.0
        d = a - b - c
        d.x.should eq -7.0
        d.y.should eq -8.0
      end

      it "descreases point's coordinates" do
        p = PointF.new 1.0, 2.0
        p -= PointF.new 3.0, 4.0
        p.x.should eq -2.0
        p.y.should eq -2.0
      end
    end

    describe "*" do
      it "multiplies point with float" do
        a = PointF.new 1.0, 2.0
        b = a * 1.4
        b.x.should eq 1.4
        b.y.should eq 2.8
      end

      it "multiplies point's coordinate" do
        p = PointF.new 1.0, 2.0
        p *= 1.4
        p.x.should eq 1.4
        p.y.should eq 2.8
      end
    end

    describe "/" do
      it "divides point with float" do
        a = PointF.new 10.0, 15.0
        b = a / 1.3
        b.x.should eq 10.0 / 1.3
        b.y.should eq 15.0 / 1.3
      end

      it "divides point's coordinate" do
        p = PointF.new 10.0, 15.0
        p /= 1.4
        p.x.should eq 10.0 / 1.4
        p.y.should eq 15.0 / 1.4
      end
    end

    describe "dot_product" do
      it "calculates dot product" do
        a = PointF.new 3.1, 7.1
        b = PointF.new -1.0, 4.1
        c = a.dot_product b
        c.should be_close 26.01, 0.1
      end

      it "calculates dot product" do
        a = PointF.new 3.1, 7.1
        b = PointF.new -1.0, 4.1
        c = PointF.dot_product a, b
        c.should be_close 26.01, 0.1
      end
    end

    describe "to_point" do
      it "" do
        pf = PointF.new 3.55, 7.1
        pi = pf.to_point
        pi.x.should eq 4
        pi.y.should eq 7
      end
    end
  end
end
