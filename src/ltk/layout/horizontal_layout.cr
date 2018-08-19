require "./box_layout_item"
require "./layout_math"

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
      item_datas = @items.map {|item| item.data }
      widths = LayoutMath.calculate_widths item_datas, @geometry.width
      puts "widths:"
      pp widths
      x = @geometry.x
      @items.each_with_index do |item, index|
        item.geometry = Rect.new(x, item.y, widths[index], item.height)
        x += widths[index]
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
