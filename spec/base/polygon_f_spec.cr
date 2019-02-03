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
  end
end
