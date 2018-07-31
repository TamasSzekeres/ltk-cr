require "./box_layout_item"

module Ltk
  module LayoutMath
    extend self
  
    def calculateWidths(items : Array(BoxLayoutItemData), layout_width : Int32) : Array(Int32)
      count = items.size
      
      return [calculateWidth(items.first, layout_width)] if count == 1
      
      widths = Array(Int32).new(count, 0)
      
      sum_stretch = 0
      items.each_width_index do |item, index|
        sum_stretch += item.stretch
      end
      
      items.each_with_index do |item, index|
        widths[index] = layout_width * item.stretch / sum_stretch
      end
      
      widths
    end
    
    def calculateWidth(item : BoxLayoutItemData, layout_width : Int32) : Int32
      if item.preferred_width == layout_width
        layout_width
      elsif item.preferred_width < layout_width
        item.maximum_width < layout_width ? item.maximum_width : layout_width
      else
        0
      end
    end
  end
end
