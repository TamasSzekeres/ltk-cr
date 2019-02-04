require "../spec_helper"
require "../../src/ltk/base/polygon_f"

include Ltk

describe Ltk do
  describe PolygonF do
    describe "isect_line" do
      it "should calculates winding" do
        PolygonF.isect_line(
          PointF.new(0.0, 0.0), PointF.new(10.0, 10.0),
          pos: PointF.new(10.0, 0.0), winding: 0).should eq(1)
        PolygonF.isect_line(
          PointF.new(0.0, 0.0), PointF.new(10.0, 10.0),
          pos: PointF.new(0.0, 10.0), winding: 0).should eq(0)
      end
    end

    describe "#contains" do
      it "should determine whether point is within a polygon or not" do
        # Rect shape
        poly = PolygonF.new(RectF.new(0.0, 0.0, 20.0, 20.0))
        poly.contains?(PointF.new(10.0, 10.0)).should be_true
        poly.contains?(PointF.new(30.0, 30.0)).should be_false

        # L shape
        poly = PolygonF.new([
          PointF.new(0.0, 0.0),
          PointF.new(10.0, 0.0),
          PointF.new(10.0, 10.0),
          PointF.new(20.0, 10.0),
          PointF.new(20.0, 20.0),
          PointF.new(0.0, 20.0)
        ])
        poly.contains?(PointF.new(5.0, 2.0)).should be_true
        poly.contains?(PointF.new(15.0, 5.0)).should be_false
      end
    end
  end
end
