require "../base/rect"
require "../base/size_policies"
require "../enums/alignment"
require "./box_layout_item"

module Ltk
  struct BoxLayoutItemData
    property preferred_size : Size
    property minimum_size : Size
    property maximum_size : Size
    property stretch : Int32
    property alignment : Alignment
    property size_policies : SizePolicies

    def initialize(@preferred_size : Size,
                   @minimum_size : Size = Size::ZERO,
                   @maximum_size : Size = Size::MAX,
                   @stretch : Int32 = 0,
                   @alignment : Alignment = Alignment::Center,
                   @size_policies : SizePolicies = SizePolicies::EXPANDING)
    end

    def initialize(item : BoxLayoutItem)
      @preferred_size = item.preferred_size
      @minimum_size = item.minimum_size
      @maximum_size = item.maximum_size
      @stretch = item.stretch
      @alignment = item.alignment
      @size_policies = item.size_policies
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
