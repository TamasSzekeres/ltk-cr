require "./box_layout_item"

module Ltk
  class HorizontalLayout < Layout
    DEFAULT_STETCH = 0

    alias Items = Array(BoxLayoutItem)

    private getter items : Items = Items.new

    def initialize(@parent : (Widget | Layout)? = nil)
      if @parent.is_a? Widget
        @parent.as(Widget).layout = self
      end
    end

    def add_item(item : (Widget | Layout), stretch : Int32 = DEFAULT_STETCH, alignment : Alignment = Alignment::None)
      raise ArgumentError.new("Stretch cannot be less then 1!") if stretch < 1
      @items << BoxLayoutItem.new(item, stretch, alignment)
    end

    def add_widget(widget : Widget, stretch : Int32 = DEFAULT_STETCH, alignment : Alignment = Alignment::None)
      add_item widget, stretch, alignment
    end

    protected def arrange_items
      count = @items.size
      item_widths = Array(Int32).new(count, 0)

      sum_stretch = 0_i64
      sum_preferred_width = 0_i64
      sum_min_width = 0_i64
      sum_max_width = 0_i64
      puts "-------------------------------------------------"
      @items.each_with_index do |item, index|
        sum_stretch += item.stretch
        preferred_width = item.preferred_width
        minimum_width = item.minimum_width
        maximum_width = item.maximum_width
        puts "item[#{index}].preferred_width = #{preferred_width}"
        #puts "item.minimum_width = #{minimum_width}"
        #puts "item.maximum_width = #{maximum_width}"
        sum_preferred_width += preferred_width if preferred_width > 0
        sum_min_width += minimum_width if minimum_width > 0
        sum_max_width += maximum_width if maximum_width > 0

        item_widths[index] = preferred_width
      end
      puts "layout-width = #{@geometry.width}"
      puts "sum-stretch = #{sum_stretch}"
      puts "sum-preferred-width = #{sum_preferred_width}"
      #puts "sum-min-width = #{sum_min_width}"
      #puts "sum-max-width = #{sum_max_width}"
      p item_widths

      if sum_preferred_width < @geometry.width
        remaining_width = @geometry.width - sum_preferred_width
        puts "remaining-width = #{remaining_width}"
        @items.each_with_index do |item, index|
            w_stretch = @geometry.width * item.stretch / sum_stretch
            if item_widths[index] < w_stretch && item.stretch > 0
              item_widths[index] = Math.max(w_stretch, item_widths[index])
            end
        end
      #else if sum_preferred_width > @geometry.width
      
      end
      p item_widths
      x = @geometry.x
      @items.each_with_index do |item, index|
        item.geometry = Rect.new(x, item.y, item_widths[index], item.height)
        x += item_widths[index]
      end
    end

    def remove_items
      @items.clear
    end

    def preferred_size : Size
      Size.new
    end

    def minimum_size : Size
      Size.new
    end

    def maximum_size : Size
      Size.new
    end
  end
end
