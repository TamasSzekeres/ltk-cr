require "../base/base_object"
require "../base/rect"
require "../base/size"
require "../base/size_policies"
require "../widget/widget"
require "./layout"

module Ltk
  abstract class LayoutItem < BaseObject
    getter item : (Widget | Layout)
    property alignment : Alignment = Alignment::Center
    property size_policies : SizePolicies

    def initialize(@item : (Widget | Layout), @alignment = Alignment::Center,
                   @size_policies : SizePolicies = SizePolicies::EXPANDING)
    end

    @[AlwaysInline]
    def x : Int32
      geometry.x
    end

    @[AlwaysInline]
    def y : Int32
      geometry.y
    end

    @[AlwaysInline]
    def width : Int32
      geometry.width
    end

    @[AlwaysInline]
    def height : Int32
      geometry.height
    end

    def geometry : Rect
      case @item
        when Widget then @item.as(Widget).geometry
        when Layout then Rect.new
        else
          Rect.new
      end
    end

    def geometry=(r : Rect)
      case @item
        when Widget
          @item.as(Widget).geometry = r
      end
    end

    def preferred_size : Size
      case @item
        when Widget then @item.as(Widget).preferred_size
      else
        Size::ZERO
      end
    end

    def preferred_width : Int32
      case @item
        when Widget then @item.as(Widget).preferred_width
      else
        0
      end
    end

    def preferred_height : Int32
      case @item
        when Widget then @item.as(Widget).preferred_width
        else
          0
      end
    end

    def minimum_size : Size
      case @item
        when Widget then @item.as(Widget).minimum_size
      else
        Size::ZERO
      end
    end

    def minimum_width : Int32
      case @item
        when Widget then @item.as(Widget).minimum_width
        else
          0
      end
    end

    def minimum_height : Int32
      case @item
        when Widget then @item.as(Widget).minimum_height
        else
          0
      end
    end

    def maximum_size : Size
      case @item
        when Widget then @item.as(Widget).maximum_size
      else
        Size::ZERO
      end
    end

    def maximum_width : Int32
      case @item
        when Widget then @item.as(Widget).maximum_width
        else
          0
      end
    end

    def maximum_height : Int32
      case @item
        when Widget then @item.as(Widget).maximum_height
        else
          0
      end
    end
  end
end
