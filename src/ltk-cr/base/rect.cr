require "./point"
require "./size"

module Ltk
  struct Rect
    @x2 = uninitialized Int32
    @y2 = uninitialized Int32

    def initialize(x : Int32, y : Int32, w : Int32, h : Int32)
      @x1 = x
      @y1 = y
      @x2 = x + w - 1
      @y2 = y + h - 1
    end

    def initialize(top_left : Point, bottom_right : Point)
      @x1 = top_left.x
      @y1 = top_left.y
      @x2 = bottom_right.x
      @y2 = bottom_right.y
    end

    def initialize(top_left : Point, size : Size)
      @x1 = top_left.x
      @y1 = top_left.y
      @x2 = top_left.x + size.width - 1
      @y2 = top_left.y + size.height - 1
    end

    @[AlwaysInline]
    def null?
      @x2 == @x1 - 1 && @y2 == @y1 - 1
    end

    @[AlwaysInline]
    def empty?
      @x1 > @x2 || @y1 > @y2
    end

    @[AlwaysInline]
    def valid?
      @x1 <= @x2 && @y1 <= @y2
    end

    @[AlwaysInline]
    def left
      @x1
    end

    @[AlwaysInline]
    def left=(pos)
      @x1 = pos
    end

    @[AlwaysInline]
    def top
      @y1
    end

    @[AlwaysInline]
    def top=(pos)
      @y1 = pos
    end

    @[AlwaysInline]
    def right
      @x2
    end

    @[AlwaysInline]
    def right=(pos)
      @x2 = pos
    end

    @[AlwaysInline]
    def bottom
      @y2
    end

    @[AlwaysInline]
    def bottom=(pos)
      @y2 = pos
    end

    @[AlwaysInline]
    def x
      @x1
    end

    @[AlwaysInline]
    def x=(pos)
      @x1 = pos
    end

    @[AlwaysInline]
    def y
      @y1
    end

    @[AlwaysInline]
    def y=(pos)
      @y1 = pos
    end

    @[AlwaysInline]
    def top_left
      Point.new @x1, @y1
    end

    @[AlwaysInline]
    def top_left=(p)
      @x1 = p.x
      @y1 = p.y
    end

    @[AlwaysInline]
    def top_right
      Point.new @x2, @y1
    end

    @[AlwaysInline]
    def top_right=(p)
      @x2 = p.x
      @y1 = p.y
    end

    @[AlwaysInline]
    def bottom_left
      Point.new @x1, @y2
    end

    @[AlwaysInline]
    def bottom_left=(p)
      @x1 = p.x
      @y2 = p.y
    end

    @[AlwaysInline]
    def bottom_right
      Point.new @x2, @y2
    end

    @[AlwaysInline]
    def bottom_right=(p)
      @x2 = p.x
      @y2 = p.y
    end

    @[AlwaysInline]
    def center
      Point.new (@x1 + @x2) / 2, (@y1 + @y2) / 2
    end

    @[AlwaysInline]
    def width
      @x2 - @x1 + 1
    end

    @[AlwaysInline]
    def width=(width)
      @x2 = @x1 + width - 1
    end

    @[AlwaysInline]
    def height
      @y2 - @y1 + 1
    end

    @[AlwaysInline]
    def height=(height)
      @y2 = @y1 + height - 1
    end

    @[AlwaysInline]
    def size
      Size.new self.width, self.height
    end

    @[AlwaysInline]
    def size=(size)
      self.width = size.width
      self.height = size.height
    end

    def translate(dx, dy)
      @x1 += dx
      @x2 += dx
      @y1 += dy
      @y2 += dy
    end

    def translate(p)
      @x1 += p.x
      @x2 += p.x
      @y1 += p.y
      @y2 += p.y
    end

    @[AlwaysInline]
    def translated(dx, dy)
      Rect.new Point.new(@x1 + dx, @y1 + dy), Point.new(@x2 + dx, @y2 + dy)
    end

    @[AlwaysInline]
    def translated(p)
      Rect.new Point.new(@x1 + p.x, @y1 + p.y), Point.new(@x2 + p.x, @y2 + p.y)
    end

    def transposed
      Rect.new top_left, size.transposed
    end

    def move_to(x, y)
      @x2 += x - @x1
      @y2 += y - @y1
      @x1 = x
      @y1 = y
    end

    def move_to(p)
      @x2 += p.x - @x1
      @y2 += p.y - @y1
      @x1 = p.x
      @y1 = p.y
    end

    def move_left(pos)
      @x2 += pos - @x1
      @x1 = pos
    end

    def move_right(pos)
      @x1 += pos - @x2
      @x2 = pos
    end

    def move_top(pos)
      @y2 += pos - @y1
      @y1 = pos
    end

    def move_bottom(pos)
      @y1 += pos - @y2
      @y2 = pos
    end

    def move_top_left(p)
      move_left p.x
      move_top p.y
    end

    def move_bottom_right(p)
      move_right p.x
      move_bottom p.y
    end

    def move_top_right(p)
      move_right p.y
      move_top p.y
    end

    def move_bottom_left(p)
      move_left p.x
      move_bottom p.y
    end

    def move_center(p)
      w = @x2 - @x1
      h = @y2 - @y1
      @x1 = p.x - w / 2
      @y1 = p.y - h / 2
      @x2 = @x1 + w
      @y2 = @y1 + h
    end

    @[AlwaysInline]
    def set_coords(x1, y1, x2, y2)
      @x1 = x1
      @y1 = y1
      @x2 = x2
      @y2 = y2
    end

    @[AlwaysInline]
    def adjusted(x1, y1, x2, y2)
      Rect.new Point.new(@x1 + x1, @y1 + y1), Point.new(@x2 + x2, @y2 + y2)
    end

    def adjust(dx1, dy1, dx2, dy2)
      @x1 += dx1
      @y1 += dy1
      @x2 += dx2
      @y2 += dy2
    end

    def normalized
      r = uninitialized Rect
      if @x2 < @x1 - 1
        r.left = @x2
        r.right = @x1
      else
        r.left = @x1
        r.right = @x2
      end
      if @y2 < @y1 - 1
        r.top = @y2
        r.bottom = @y1
      else
        r.top = @y1
        r.bottom = @y2
      end
      r
    end

    def contains?(x, y, proper = false)
      r = self.normalized
      unless proper
        (x >= r.left) && (x <= r.right) &&
        (y >= r.top) && (y <= r.bottom)
      else
        (x > r.left) && (x < r.right) &&
        (y > r.top) && (y < r.bottom)
      end
    end

    @[AlwaysInline]
    def contains?(p : Point, proper = false)
      contains? p.x, p.y, proper
    end

    @[AlwaysInline]
    def contains?(rect : Rect, proper = false)
      contains?(rect.top_left, proper) &&
      contains?(rect.bottom_right, proper)
    end
  end
end
