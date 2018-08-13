require "../spec_helper"
require "../../src/ltk/base/size"
require "../../src/ltk/layout/box_layout_item_data"
require "../../src/ltk/layout/layout_math"

include Ltk

describe Ltk do
  describe LayoutMath do
    describe "#calculateWidths" do
      it "properly calculates width for one item" do
        item = BoxLayoutItemData.new(Size.new(100, 0), Size.new(50, 0), Size.new(150, 0), 0, Alignment::Center)
        LayoutMath.calculateWidths([item], 25).should eq([50])
        LayoutMath.calculateWidths([item], 50).should eq([50])
        LayoutMath.calculateWidths([item], 100).should eq([100])
        LayoutMath.calculateWidths([item], 150).should eq([150])
        LayoutMath.calculateWidths([item], 200).should eq([150])
      end

      it "properly calculates width for two items width 0 stretch factors" do
        item1 = BoxLayoutItemData.new(Size.new(100, 0), Size.new(50, 0), Size.new(150, 0), 0, Alignment::Center)
        item2 = BoxLayoutItemData.new(Size.new(100, 0), Size.new(50, 0), Size.new(150, 0), 0, Alignment::Center)
        LayoutMath.calculateWidths([item1, item2], 200).should eq([100, 100])
      end
    end

    describe "#calculateWidth" do
      it "properly calculates width for one item" do
        item = BoxLayoutItemData.new(Size.new(100, 0), Size.new(50, 0), Size.new(150, 0), 0, Alignment::Center)
        LayoutMath.calculateWidth(item, 25).should eq(50)
        LayoutMath.calculateWidth(item, 50).should eq(50)
        LayoutMath.calculateWidth(item, 100).should eq(100)
        LayoutMath.calculateWidth(item, 150).should eq(150)
        LayoutMath.calculateWidth(item, 200).should eq(150)
      end
    end
  end
end
