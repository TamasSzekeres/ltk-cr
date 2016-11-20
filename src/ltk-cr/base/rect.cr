module Ltk
  struct Rect
    property x : Int32
    property y : Int32
    property width : Int32
    property height : Int32

    def initialize(@x, @y, @width, @height)
    end

    def contains?(x, y)
      (x >= @x) && (x <= right) &&
      (y >= @y) && (y <= bottom)
    end

    def contains?(p)
      contains? p.x, p.y
    end

    def left
      @x
    end

    def right
      @x + @width
    end

    def top
      @y
    end

    def bottom
      @y + @height
    end

    def top_left
      Point.new left, top
    end

    def top_right
      Point.new right, top
    end

    def bottom_left
      Point.new left, bottom
    end

    def bottom_left
      Point.new right, bottom
    end
  end
end
