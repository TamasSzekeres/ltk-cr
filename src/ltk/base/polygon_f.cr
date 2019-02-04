require "./point"
require "./rect"

module Ltk
  struct PolygonF
    include Indexable(PointF)

    property points : Array(PointF)

    def initialize(@points : Array(PointF))
    end

    def initialize(size : Int)
      @points = Array(PointF).new(initial_capacity: size)
    end

    def initialize(size : Int, &block : Int32 -> PointF)
      @points = Array(PointF).new(size, block)
    end

    def initialize(rect : RectF, closed : Bool = false)
      @points = Array(PointF).new(closed ? 5 : 4)
      @points << rect.top_left << rect.top_right << rect.bottom_right << rect.bottom_left
      if closed
        @points << rect.top_left
      end
    end

    def bounding_rect : RectF
      min = PointF::MAX
      max = PointF::ZERO
      @points.each do |p|
        if p.x < min.x
          min.x = p.x
        elsif p.x > max.x
          max.x = p.x
        end
        if p.y < min.y
          min.y = p.y
        elsif p.y > max.y
          max.y = p.y
        end
      end
      RectF.new(min, max)
    end

    def contains?(p : PointF, fill_rule = 0) : Bool
      return false if empty?

      winding_number = 0

      last_pt = unsafe_fetch(0)
      last_start = unsafe_fetch(0)
      (1...size).each do |i|
        e = unsafe_fetch(i)
        winding_number = PolygonF.isect_line(last_pt, e, p, winding_number)
        last_pt = e
      end
  
      if last_pt != last_start
        winding_number = PolygonF.isect_line(last_pt, last_start, p, winding_number)
      end
  
      (fill_rule == 1) ? (winding_number != 0) : ((winding_number % 2) != 0)
    end

    def closed? : Bool
      if size > 2
        @points[0] == @points[-1]
      else
        false
      end
    end

    def self.isect_line(p1 : PointF, p2 : PointF, pos : PointF, winding : Int32) : Int32
      x1, y1 = p1.x, p1.y
      x2, y2 = p2.x, p2.y
      y = pos.y

      dir = 1

      if y1 == y2
        return winding
      elsif y2 < y1
        x1, x2 = x2, x1
        y1, y2 = y2, y1
        dir = -1
      end

      if y >= y1 && y < y2
        x = x1 + ((x2 - x1) / (y2 - y1)) * (y - y1)

        if x <= pos.x
          winding += dir
        end
      end

      winding
    end

    def translate(offset : PointF)
      unless offset.is_null?
        @points.map &.+(offset)
      end
      self
    end

    @[AlwaysInline]
    def translate(dx : Float64, dy : Float64)
      translate(PointF.new(dx, dy))
    end

    def translated(offset : PointF) : PolygonF
      PolygonF.new(@points.map &.+(offset))
    end

    @[AlwaysInline]
    def translated(dx : Float64, dy : Float64) : PolygonF
      translated(PointF.new(dx, dy))
    end

    def size
      @points.size
    end

    def unsafe_fetch(index : Int)
      @points.unsafe_fetch(index)
    end
  end
end
