module Ltk
  struct Point
    property x : Int32
    property y : Int32

    def initialize(@x = Int32.zero, @y = Int32.zero)
    end

    @[AlwaysInline]
    def manhattan_length
      @x.abs + @y.abs
    end

    @[AlwaysInline]
    def is_null?
      @x == Int32.zero && @y == Int32.zero
    end

    @[AlwaysInline]
    def +(p)
      Point.new @x + p.x, @y + p.y
    end

    @[AlwaysInline]
    def -(p)
      Point.new @x - p.x, @y - p.y
    end

    @[AlwaysInline]
    def *(factor)
      Point.new @x * factor, @y * factor
    end

    @[AlwaysInline]
    def *(factor : Float)
      Point.new (@x * factor).round.to_i, (@y * factor).round.to_i
    end

    @[AlwaysInline]
    def /(c : Float)
      Point.new (@x / c).round.to_i, (@y / c).round.to_i
    end
  end
end
