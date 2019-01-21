module Ltk
  struct Point
    property x : Int32
    property y : Int32

    ZERO = Point.new(0, 0)

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
    def *(factor : Int)
      Point.new @x * factor, @y * factor
    end

    @[AlwaysInline]
    def *(factor : Float32 | Float64)
      Point.new (@x * factor).round.to_i, (@y * factor).round.to_i
    end

    @[AlwaysInline]
    def /(c : Float32 | Float64)
      Point.new (@x / c).round.to_i, (@y / c).round.to_i
    end
  end

  struct PointF
    property x : Float64
    property y : Float64

    def initialize(@x = Float64.zero, @y = Float64.zero)
    end

    def initialize(p : Point)
      @x = p.x
      @y = p.y
    end

    @[AlwaysInline]
    def manhattan_length
      @x.abs + @y.abs
    end

    @[AlwaysInline]
    def is_null?
      @x == Float64.zero && @y == Float64.zero
    end

    @[AlwaysInline]
    def +(p)
      PointF.new @x + p.x, @y + p.y
    end

    @[AlwaysInline]
    def -(p)
      PointF.new @x - p.x, @y - p.y
    end

    @[AlwaysInline]
    def *(factor)
      PointF.new @x * factor, @y * factor
    end

    @[AlwaysInline]
    def /(c)
      PointF.new @x / c, @y / c
    end

    @[AlwaysInline]
    def dot_product(p)
      @x * p.x + @y * p.y
    end

    @[AlwaysInline]
    def self.dot_product(p1, p2)
      p1.x * p2.x + p1.y * p2.y
    end

    @[AlwaysInline]
    def to_point
      Point.new @x.round.to_i, @y.round.to_i
    end
  end
end
