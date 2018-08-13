require "./box_layout_item"

module Ltk
  module LayoutMath
    extend self

    def calculateWidths(items : Array(BoxLayoutItemData), layout_width : Int32) : Array(Int32)
      count = items.size

      return [calculateWidth(items.first, layout_width)] if count == 1

      widths = Array(Int32).new(count, 0)

      sum_stretch = 0
      items.each_with_index do |item, index|
        sum_stretch += item.stretch
      end

      width_remaining = layout_width
      items.each_with_index do |item, index|
        if item.stretch == 0
          widths[index] = Math.min(item.preferred_width, width_remaining)
          width_remaining -= widths[index]
        end
      end

      if sum_stretch > 0
        items.each_with_index do |item, index|
          if item.stretch > 0
            widths[index] = width_remaining * item.stretch  / sum_stretch
          end
        end
      end

      widths
    end

    def calculateWidth(item : BoxLayoutItemData, layout_width : Int32) : Int32
      if layout_width <= item.minimum_width
        item.minimum_width
      elsif layout_width <= item.preferred_width
        item.preferred_width
      else
        Math.min(layout_width, item.maximum_width)
      end
    end
  end
end
