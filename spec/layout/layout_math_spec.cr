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
        LayoutMath.calculateWidths([item], 100).should eq([100])
      end
    end
  end
end
