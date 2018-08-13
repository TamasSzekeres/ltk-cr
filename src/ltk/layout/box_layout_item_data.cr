require "../base/rect"
require "./alignment"
require "./box_layout_item"

module Ltk
  struct BoxLayoutItemData
    getter preferred_size : Size
    getter minimum_size : Size
    getter maximum_size : Size
    getter stretch : Int32
    getter alignment : Alignment

    def initialize(@preferred_size : Size,
                   @minimum_size : Size = Size::ZERO,
                   @maximum_size : Size = Size::MAX,
                   @stretch : Int32 = 0,
                   @alignment : Alignment = Alignment::Center)
    end

    def initialize(item : BoxLayoutItem)
      @preferred_size = item.preferred_size
      @minimum_size = item.minimum_size
      @maximum_size = item.maximum_size
      @stretch = item.stretch
      @alignment = item.alignment
    end

    @[AlwaysInline]
    def preferred_width : Int32
      @preferred_size.width
    end

    @[AlwaysInline]
    def preferred_height : Int32
      @preferred_size.height
    end

    @[AlwaysInline]
    def minimum_width : Int32
      @minimum_size.width
    end

    @[AlwaysInline]
    def minimum_height : Int32
      @minimum_size.height
    end

    @[AlwaysInline]
    def maximum_width : Int32
      @maximum_size.width
    end

    @[AlwaysInline]
    def maximum_height : Int32
      @maximum_size.height
    end
  end
end
