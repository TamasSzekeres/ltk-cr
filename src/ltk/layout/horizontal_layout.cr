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
    end

    alias Items = Array(Item)

    private getter items : Items = Items.new

    def initialize(@parent : (Widget | Layout)? = nil)
      if @parent.is_a? Widget
        @parent.as(Widget).layout = self
      end
    end

    def add_item(item : (Widget | Layout), stretch : Int32 = DEFAULT_STETCH)
      @items << Item.new(item, stretch)
    end

    def add_widget(widget : Widget, stretch : Int32 = DEFAULT_STETCH)
      add_item widget, stretch
    end

    protected def arrange_items
      count = @items.size
      w = @geometry.width / count
      @items.each_with_index do |item, index|
        item.geometry = Rect.new(@geometry.x + (index * w), (item.y), w, item.height)
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
