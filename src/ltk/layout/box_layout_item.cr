require "./box_layout_item_data"
require "./layout_item"

module Ltk
  class BoxLayoutItem < LayoutItem
    DEFAULT_STRETCH = 0
    MINIMUM_STRETCH = 0

    property stretch : Int32 = DEFAULT_STRETCH

    def initialize(item : (Widget | Layout), @stretch : Int32 = DEFAULT_STETCH, alignment : Alignment = Alignment::None)
      raise ArgumentError.new("stretch cannot be less than #{MINIMUM_STRETCH}") if @stretch < MINIMUM_STRETCH
      super(item, alignment)
    end

    def data : BoxLayoutItemData
      BoxLayoutItemData.new(preferred_size, minimum_size, maximum_size, stretch, alignment, size_policies)
    end
  end
end
