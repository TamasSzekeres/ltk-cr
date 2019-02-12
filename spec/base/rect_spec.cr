require "../spec_helper"
require "../../src/ltk/base/rect"
require "../../src/ltk/enums/alignment"

include Ltk

describe Ltk::Rect do
  it "should calc aligned property" do
    bounding = Rect.new(10, 10, 100, 80)
    Rect.aligned(bounding, 40, 60, Alignment::TopLeft).should eq(Rect.new(10, 10, 40, 60))
    Rect.aligned(bounding, 40, 60, Alignment::TopCenter).should eq(Rect.new(40, 10, 40, 60))
    Rect.aligned(bounding, 40, 60, Alignment::TopRight).should eq(Rect.new(70, 10, 40, 60))
    Rect.aligned(bounding, 40, 60, Alignment::CenterLeft).should eq(Rect.new(10, 20, 40, 60))
    Rect.aligned(bounding, 40, 60, Alignment::Center).should eq(Rect.new(40, 20, 40, 60))
    Rect.aligned(bounding, 40, 60, Alignment::CenterRight).should eq(Rect.new(70, 20, 40, 60))
    Rect.aligned(bounding, 40, 60, Alignment::BottomLeft).should eq(Rect.new(10, 30, 40, 60))
    Rect.aligned(bounding, 40, 60, Alignment::BottomCenter).should eq(Rect.new(40, 30, 40, 60))
    Rect.aligned(bounding, 40, 60, Alignment::BottomRight).should eq(Rect.new(70, 30, 40, 60))
  end
end