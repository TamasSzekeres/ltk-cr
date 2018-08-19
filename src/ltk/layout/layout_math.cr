require "./box_layout_item"

module Ltk
  module LayoutMath
    extend self

    def calculateWidths(items : Array(BoxLayoutItemData), layout_width : Int32) : Array(Int32)
      return [calculateWidth(items.first, layout_width)] if items.size == 1

      sum_minimum_width = 0
      sum_maximum_width = 0
      sum_min_zs = 0
      sum_min_ps = 0
      sum_max_zs = 0
      sum_max_ps = 0
      sum_pref_zs = 0
      sum_pref_ps = 0
      sum_stretch = 0

      items.each_with_index do |item, index|
        sum_minimum_width += item.minimum_width
        sum_maximum_width += item.maximum_width
        if item.stretch == 0
          sum_min_zs += item.minimum_width
          sum_max_zs += item.maximum_width
          sum_pref_zs += item.preferred_width
        else
          sum_min_ps += item.minimum_width
          sum_max_ps += item.maximum_width
          sum_pref_ps += item.preferred_width
        end
        sum_stretch += item.stretch
      end

      if sum_minimum_width >= layout_width
        items.map do |item|
          item.minimum_width
        end
      elsif layout_width <= sum_pref_zs + sum_min_ps
        remaining_width = layout_width - sum_min_ps
        items.map do |item|
          if item.stretch == 0
            remaining_width * item.preferred_width / sum_pref_zs
          else
            item.minimum_width
          end
        end
      elsif layout_width <= sum_pref_zs + sum_max_ps
        remaining_width = layout_width - sum_pref_zs
        remaining_stretch = sum_stretch
        expandables = [] of Int32
        sum_ex_stretch = 0
        sum_widths = 0
        widths = items.map_with_index do |item, index|
          if item.stretch == 0
            item.preferred_width
          else
            width = Math.min(remaining_width * item.stretch / remaining_stretch, item.maximum_width)
            remaining_width -= width
            remaining_stretch -= item.stretch
            if width < item.maximum_width
              sum_ex_stretch += item.stretch
              expandables << index
            end
            width
          end
        end
        while expandables.size > 0 && remaining_width >= expandables.size
          remaining_stretch = sum_ex_stretch
          sum_ex_stretch = 0
          expandables.each do |ex_idx|
            item = items[ex_idx]
            width = widths[ex_idx] + (remaining_width * item.stretch / remaining_stretch)
            width = item.maximum_width if width > item.maximum_width
            remaining_width -= width
            remaining_stretch -= item.stretch
            widths[ex_idx] = width
          end
        end
        widths
      elsif layout_width <= sum_maximum_width
        remaining_width = layout_width - sum_max_ps
        items.map do |item|
          if item.stretch == 0
            remaining_width * item.maximum_width / sum_max_zs
          else
            item.maximum_width
          end
        end
      else
        items.map do |item|
          item.maximum_width
        end
      end
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
