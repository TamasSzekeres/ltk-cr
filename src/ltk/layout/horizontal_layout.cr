module Ltk
  class HorizontalLayout < Layout
    DEFAULT_STETCH = 1

    struct Item
      getter item : (Widget | Layout)
      property stretch : Int32 = 1

      def initialize(@item : (Widget | Layout), @stretch : Int32 = DEFAULT_STETCH)
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

    alias Items = Array(Item)

    private getter items : Items = Items.new

    def initialize(@parent : (Widget | Layout)? = nil)
      if @parent.is_a? Widget
        @parent.as(Widget).layout = self
      end
    end

    def add_item(item : (Widget | Layout), stretch : Int32 = DEFAULT_STETCH)
      raise ArgumentError.new("Stretch cannot be less then 1!") if stretch < 1
      @items << Item.new(item, stretch)
    end

    def add_widget(widget : Widget, stretch : Int32 = DEFAULT_STETCH)
      add_item widget, stretch
    end

    protected def arrange_items
      count = @items.size
      item_widths = Array(Int32).new(count, 0)

      sum_stretch = 0_i64
      sum_preferred_width = 0_i64
      sum_min_width = 0_i64
      sum_max_width = 0_i64
      @items.each_with_index do |item, index|
        sum_stretch += item.stretch
        preferred_width = item.preferred_width
        minimum_width = item.minimum_width
        maximum_width = item.maximum_width
        puts "item.preferred_width = #{preferred_width}"
        puts "item.minimum_width = #{minimum_width}"
        puts "item.maximum_width = #{maximum_width}"
        sum_preferred_width += preferred_width if preferred_width > 0
        sum_min_width += minimum_width if minimum_width > 0
        sum_max_width += maximum_width if maximum_width > 0

        item_widths[index] = preferred_width
      end
      puts "-------------------------------------------------"
      puts "layout-width = #{@geometry.width}"
      puts "sum-stretch = #{sum_stretch}"
      puts "sum-preferred-width = #{sum_preferred_width}"
      puts "sum-min-width = #{sum_min_width}"
      puts "sum-max-width = #{sum_max_width}"

      if sum_preferred_width < @geometry.width
        remaining_width = @geometry.width - sum_preferred_width
        @items.each_with_index do |item, index|
          item_widths[index] += remaining_width * item.stretch / sum_stretch
        end
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
