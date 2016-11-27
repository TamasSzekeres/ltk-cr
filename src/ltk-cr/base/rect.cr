require "./point"
require "./size"

module Ltk
  struct Rect
    @x1 = 0
    @y1 = 0
    @x2 = -1
    @y2 = -1

    def initialize
    end

    def initialize(x : Int32, y : Int32, width : Int32, height : Int32)
      @x1 = x
      @y1 = y
      @x2 = x + width - 1
      @y2 = y + height - 1
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

    @[AlwaysInline]
    def translate(dx, dy)
      @x1 += dx
      @x2 += dx
      @y1 += dy
      @y2 += dy
      self
    end

    @[AlwaysInline]
    def translate(p)
      @x1 += p.x
      @x2 += p.x
      @y1 += p.y
      @y2 += p.y
      self
    end

    @[AlwaysInline]
    def translated(dx, dy)
      Rect.new Point.new(@x1 + dx, @y1 + dy), Point.new(@x2 + dx, @y2 + dy)
    end

    @[AlwaysInline]
    def translated(p)
      Rect.new Point.new(@x1 + p.x, @y1 + p.y), Point.new(@x2 + p.x, @y2 + p.y)
    end

    @[AlwaysInline]
    def transposed
      Rect.new top_left, size.transposed
    end

    @[AlwaysInline]
    def move_to(x, y)
      @x2 += x - @x1
      @y2 += y - @y1
      @x1 = x
      @y1 = y
    end

    @[AlwaysInline]
    def move_to(p)
      @x2 += p.x - @x1
      @y2 += p.y - @y1
      @x1 = p.x
      @y1 = p.y
    end

    @[AlwaysInline]
    def move_left(pos)
      @x2 += pos - @x1
      @x1 = pos
    end

    @[AlwaysInline]
    def move_right(pos)
      @x1 += pos - @x2
      @x2 = pos
    end

    @[AlwaysInline]
    def move_top(pos)
      @y2 += pos - @y1
      @y1 = pos
    end

    @[AlwaysInline]
    def move_bottom(pos)
      @y1 += pos - @y2
      @y2 = pos
    end

    @[AlwaysInline]
    def move_top_left(p)
      move_left p.x
      move_top p.y
    end

    @[AlwaysInline]
    def move_bottom_right(p)
      move_right p.x
      move_bottom p.y
    end

    @[AlwaysInline]
    def move_top_right(p)
      move_right p.x
      move_top p.y
    end

    @[AlwaysInline]
    def move_bottom_left(p)
      move_left p.x
      move_bottom p.y
    end

    @[AlwaysInline]
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

    @[AlwaysInline]
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

    def united(r : Rect)
      return r if self.null?
      return self if r.null?

      r1 = self.normalized
      r2 = r.normalized

      Rect.new(
        Point.new(
          Math.min(r1.x, r2.x),
          Math.min(r1.y, r2.y)),
        Point.new(
          Math.max(r1.right, r2.right),
          Math.max(r1.bottom, r2.bottom)))
    end

    @[AlwaysInline]
    def |(r)
      self.united r
    end

    def intersected(r : Rect)
      if self.null? || r.null?
        return Rect.new
      end

      r1 = self.normalized
      r2 = r.normalized

      if r1.left > r2.right || r2.left > r1.right ||
         t1.top > r2.bottom || r2.top > r2.bottom
        return Rect.new
      end

      Rect.new(
        Point.new(
          Math.max(r1.left, r2.left),
          Math.max(r1.top, r2.top)),
        Point.new(
          Math.min(r1.right, r2.right),
          Math.min(r1.bottom, r2.bottom)))
    end

    @[AlwaysInline]
    def &(r)
      self.intersected r
    end

    def intersects?(r : Rect)
    end
  end

  struct RectF
    property x : Float64
    property y : Float64
    property width : Float64
    property height : Float64

    def initialize
      @x = 0.0
      @y = 0.0
      @width = 0.0
      @height = 0.0
    end

    def initialize(top_left : PointF, size : SizeF)
      @x = top_left.x
      @y = top_left.y
      @width = size.width
      @height = size.height
    end

    def initialize(top_left : PointF, bottom_right : PointF)
      @x = top_left.x
      @y = top_left.y
      @width = bottom_right.x - @x
      @height = bottom_right.y - @y
    end

    def initialize(left, top, @width, @height)
      @x = left
      @y = top
    end

    def initialize(rect : Rect)
      @x = rect.x
      @y = rect.y
      @width = rect.width
      @height = rect.height
    end

    @[AlwaysInline]
    def null?
      @width == 0.0 && @height == 0.0
    end

    @[AlwaysInline]
    def empty?
      @width <= 0.0 || @height <= 0.0
    end

    @[AlwaysInline]
    def valid?
      @width > 0 && @height > 0
    end

    def normalized
      r = self
      if r.width < 0.0
        r.x = r.x + r.width
        r.width = -r.width
      end
      if r.height < 0.0
        r.y = r.y + r.height
        r.height = -r.height
      end
      r
    end

    @[AlwaysInline]
    def left
      @x
    end

    @[AlwaysInline]
    def left=(pos)
      @x = pos
    end

    @[AlwaysInline]
    def top
      @x
    end

    @[AlwaysInline]
    def top=(pos)
      @x = pos
    end

    @[AlwaysInline]
    def right
      @x + @width
    end

    @[AlwaysInline]
    def right=(pos)
      @width = pos - @x
    end

    @[AlwaysInline]
    def bottom
      @y + @height
    end

    @[AlwaysInline]
    def bottom=(pos)
      @height = pos - @y
    end

    @[AlwaysInline]
    def top_left
      PointF.new @x, @y
    end

    @[AlwaysInline]
    def top_left=(p : PointF)
      @x = p.x
      @y = p.y
    end

    @[AlwaysInline]
    def bottom_right
      PointF.new self.right, self.bottom
    end

    @[AlwaysInline]
    def bottom_right=(p : PointF)
      self.right = p.x
      self.bottom = p.y
    end

    @[AlwaysInline]
    def top_right
      PointF.new self.right, @y
    end

    @[AlwaysInline]
    def top_right=(p : PointF)
      self.right = p.x
      @y = p.y
    end

    @[AlwaysInline]
    def bottom_left
      PointF.new @x, self.bottom
    end

    @[AlwaysInline]
    def bottom_left=(p : PointF)
      @x = p.x
      self.bottom = p.y
    end

    @[AlwaysInline]
    def center
      PointF.new @x + @width / 2.0, @y + @height / 2.0
    end

    @[AlwaysInline]
    def move_left(pos)
      @x = pos
    end

    @[AlwaysInline]
    def move_right(pos)
      @x = pos - @width
    end

    @[AlwaysInline]
    def move_top(pos)
      @y = pos
    end

    @[AlwaysInline]
    def move_bottom(pos)
      @y = pos - @height
    end

    @[AlwaysInline]
    def move_top_left(p)
      move_left p.x
      move_top p.y
    end

    @[AlwaysInline]
    def move_bottom_right(p)
      move_right p.x
      move_bottom p.y
    end

    @[AlwaysInline]
    def move_top_right(p)
      move_right p.x
      move_top p.y
    end

    @[AlwaysInline]
    def move_bottom_left(p)
      move_left p.x
      move_bottom p.y
    end

    @[AlwaysInline]
    def move_center(p)
      @x = p.x - @width / 2.0
      @y = p.y - @height / 2.0
    end

    @[AlwaysInline]
    def translate(dx, dy)
      @x += dx
      @y += dy
      self
    end

    @[AlwaysInline]
    def translate(p : PointF)
      @x += p.x
      @y += p.y
      self
    end

    @[AlwaysInline]
    def translated(dx, dy)
      RectF.new @x + dx, @y + dy, @width, @height
    end

    @[AlwaysInline]
    def translated(p : PointF)
      RectF.new @x + p.x, @y + p.y, @width, @height
    end

    @[AlwaysInline]
    def transposed
      RectF.new @x, @y, @height, @width
    end

    @[AlwaysInline]
    def move_to(x, y)
      @x = x
      @y = y
      self
    end

    @[AlwaysInline]
    def move_to(p : PointF)
      @x = p.x
      @y = p.y
      self
    end

    @[AlwaysInline]
    def set_coords(x1, y1, x2, y2)
      @x1 = x1
      @y1 = y1
      @x2 = x2
      @y2 = y2
    end

    @[AlwaysInline]
    def adjust(dx1, dy1, dx2, dy2)
      @x += dx1
      @y += dy1
      @width += dx2 - dx1
      @height += dy2 - dy1
    end

    @[AlwaysInline]
    def adjusted(dx1, dy1, dx2, dy2)
      RectF.new @x + dx1, @y + dy1, @width + dx2 - dx1, @height + dy2 - dy1
    end

    @[AlwaysInline]
    def size
      SizeF.new @width, @height
    end

    @[AlwaysInline]
    def size=(s)
      @width = s.width
      @height = s.height
    end

    def contains?(x, y)
      r = self.normalized
      (x > r.left) && (x < r.right) &&
      (y > r.top) && (y < r.bottom)
    end

    @[AlwaysInline]
    def contains?(p : PointF)
      contains? p.x, p.y
    end

    @[AlwaysInline]
    def contains?(rect : RectF)
      contains?(rect.top_left) &&
      contains?(rect.bottom_right)
    end

    def united(r : RectF)
      return r if self.null?
      return self if r.null?

      r1 = self.normalized
      r2 = r.normalized

      RectF.new(
        PointF.new(
          Math.min(r1.x, r2.x),
          Math.min(r1.y, r2.y)),
        PointF.new(
          Math.max(r1.right, r2.right),
          Math.max(r1.bottom, r2.bottom)))
    end

    @[AlwaysInline]
    def |(r)
      self.united r
    end

    def intersected(r : RectF)
      if self.null? || r.null?
        return RectF.new
      end

      r1 = self.normalized
      r2 = r.normalized

      if r1.left > r2.right || r2.left > r1.right ||
         t1.top > r2.bottom || r2.top > r2.bottom
        return RectF.new
      end

      RectF.new(
        PointF.new(
          Math.max(r1.left, r2.left),
          Math.max(r1.top, r2.top)),
        PointF.new(
          Math.min(r1.right, r2.right),
          Math.min(r1.bottom, r2.bottom)))
    end

    @[AlwaysInline]
    def &(r)
      self.intersected r
    end

    def intersects?(r : RectF)
    end

    @[AlwaysInline]
    def to_rect
      Rect.new @x.round, @y.round, @width.round, @height.round
    end

    def to_aligned_rect
      xmin = @x.floor.to_i
      xmax = (@x + @width).ceil.to_i
      ymin = @y.floor
      ymax = (@y + @height).ceil.to_i
      Rect.new xmin, ymin, xmax - xmin, ymax - ymin
    end
  end
end
