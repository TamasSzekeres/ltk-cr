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

      it "properly calculates widths for two items with 0 stretch factors" do
        item1 = BoxLayoutItemData.new(Size.new(100, 0), Size.new(50, 0), Size.new(150, 0), 0, Alignment::Center)
        item2 = BoxLayoutItemData.new(Size.new(100, 0), Size.new(50, 0), Size.new(150, 0), 0, Alignment::Center)
        LayoutMath.calculateWidths([item1, item2], 200).should eq([100, 100])
      end

      it "properly calculates widths for 4 items with 0,2,3,0 stretch factors" do
        item1 = BoxLayoutItemData.new(Size.new(200, 0), Size.new( 10, 0), Size.new(400, 0), 0, Alignment::Center)
        item2 = BoxLayoutItemData.new(Size.new(200, 0), Size.new(100, 0), Size.new(400, 0), 2, Alignment::Center)
        item3 = BoxLayoutItemData.new(Size.new(200, 0), Size.new(100, 0), Size.new(400, 0), 3, Alignment::Center)
        item4 = BoxLayoutItemData.new(Size.new(200, 0), Size.new( 10, 0), Size.new(400, 0), 0, Alignment::Center)
        LayoutMath.calculateWidths([item1, item2, item3, item4], 100).should eq([10, 100, 100, 10])
        LayoutMath.calculateWidths([item1, item2, item3, item4], 220).should eq([10, 100, 100, 10])
        LayoutMath.calculateWidths([item1, item2, item3, item4], 240).should eq([20, 100, 100, 20])
        LayoutMath.calculateWidths([item1, item2, item3, item4], 600).should eq([200, 100, 100, 200])
        LayoutMath.calculateWidths([item1, item2, item3, item4], 650).should eq([200, 100, 150, 200])
        LayoutMath.calculateWidths([item1, item2, item3, item4], 1200).should eq([200, 400, 400, 200])
        LayoutMath.calculateWidths([item1, item2, item3, item4], 1400).should eq([300, 400, 400, 300])
        LayoutMath.calculateWidths([item1, item2, item3, item4], 1600).should eq([400, 400, 400, 400])
        LayoutMath.calculateWidths([item1, item2, item3, item4], 1800).should eq([400, 400, 400, 400])
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
