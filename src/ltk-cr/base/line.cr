require "./point"

module Ltk
  enum LineIntersectionType
    NoIntersection
    Bounded
    Unbounded
  end

  struct Line
    property p1 : Point
    property p2 : Point

    def initialize
      @p1 = Point.new
      @p2 = Point.new
    end

    def initialize(@p1, @p2)
    end

    def initialize(x1, y1, x2, y2)
      @p1 = Point.new x1, y1
      @p2 = Point.new x2, y2
    end

    @[AlwaysInline]
    def null?
      @p1 == @p2
    end

    @[AlwaysInline]
    def x1
      @p1.x
    end

    @[AlwaysInline]
    def x1=(pos)
      @p1.x = pos
    end

    @[AlwaysInline]
    def y1
      @p1.y
    end

    @[AlwaysInline]
    def y1=(pos)
      @p1.y = pos
    end

    @[AlwaysInline]
    def x2
      @p2.x
    end

    @[AlwaysInline]
    def x2=(pos)
      @p2.x = pos
    end

    @[AlwaysInline]
    def y2
      @p2.y
    end

    @[AlwaysInline]
    def y2=(pos)
      @p2.y = pos
    end

    @[AlwaysInline]
    def dx
      @p2.x - @p1.x
    end

    @[AlwaysInline]
    def dy
      @p2.y - @p1.y
    end

    @[AlwaysInline]
    def translate(p : Point)
      @p1 += p
      @p2 += p
      self
    end

    @[AlwaysInline]
    def translate(dx, dy)
      self.translate Point.new(dx, dy)
    end

    @[AlwaysInline]
    def translated(p : Point)
      Point.new(@p1 + p, @p2 + p)
    end

    @[AlwaysInline]
    def translated(dx, dy)
      self.translated Point.new(dx, dy)
    end

    @[AlwaysInline]
    def center(dx, dy)
      Point.new((@p1.x + @p2.x) / 2, (@p1.y + @p2.y) / 2)
    end
  end

  struct LineF
    PI2 = Math::PI * 2

    property p1 : PointF
    property p2 : PointF

    def initialize
      @p1 = PointF.new
      @p2 = PointF.new
    end

    def initialize(@p1, @p2)
    end

    def initialize(x1, y1, x2, y2)
      @p1 = PointF.new x1, y1
      @p2 = PointF.new x2, y2
    end

    def initialize(line : Line)
      @p1 = PointF.new line.p1
      @p2 = PointF.new line.p2
    end

    def self.from_polar(length : Float64, angle : Float64)
      angle_r = angle * PI2 / 360.0
      LineF.new(0.0, 0.0, Math.cos(angle_r) * length, -Math.sin(angle_r) * length)
    end

    @[AlwaysInline]
    def null?
      @p1 == @p2
    end

    @[AlwaysInline]
    def x1
      @p1.x
    end

    @[AlwaysInline]
    def x1=(pos)
      @p1.x = pos
    end

    @[AlwaysInline]
    def y1
      @p1.y
    end

    @[AlwaysInline]
    def y1=(pos)
      @p1.y = pos
    end

    @[AlwaysInline]
    def x2
      @p2.x
    end

    @[AlwaysInline]
    def x2=(pos)
      @p2.x = pos
    end

    @[AlwaysInline]
    def y2
      @p2.y
    end

    @[AlwaysInline]
    def y2=(pos)
      @p2.y = pos
    end

    @[AlwaysInline]
    def dx
      @p2.x - @p1.x
    end

    @[AlwaysInline]
    def dy
      @p2.y - @p1.y
    end

    @[AlwaysInline]
    def length
      x = self.dx
      y = self.dy
      Math.sqrt x * x + y * y
    end

    @[AlwaysInline]
    def length=(len)
      return self if self.null?

      v = self.unite_vector
      @p2 = PointF.new(@p1.x + v.dx * len, @p1.y + v.dy * len)
      self
    end

    def angle
      theta = Math.atan2(-self.dy, self.dx) * 360.0 / PI2
      theta_normalized = theta < 0 ? theta + 360 : theta
      theta_normalized == 360.0 ? 0.0 : theta_normalized
    end

    def angle=(angle : Float64)
      angle_r = angle * PI2 / 360.0
      l = length

      dx = Math.cos(angle_r) * l
      dy = -Math.sin(angle_r) * l

      @p2.x = @p1.x + dx
      @p2.y = @p1.y + dy
    end

    def angle_to(l : LineF)
      return 0.0 if self.null? || l.null?

      a1 = self.angle
      a2 = l.angle

      delta = a2 - a1
      delta_normalized = delta < 0.0 ? delta + 360.0 : delta

      delta == 360.0 ? 0.0 : delta_normalized
    end

    def unite_vector
      x = @p2.x - @p1.x
      y = @p2.y - @p1.y

      len = self.length
      LineF.new(@p1, PointF.new(@p1.x + x / len, @p1.y + y / len))
    end

    @[AlwaysInline]
    def normal_vector
      LineF.new @p1, @p1 + PointF.new(self.dy, -self.dx)
    end

    def intersection(l : LineF)
      a = @p2 - @p1
      b = l.p1 - l.p2
      c = @p1 - l.p1

      denominator = a.y * b.x - a.x * b.y
      if denominator == 0 || !denominator.finite?
        return {
          type: LineIntersectionType::NoIntersection,
          intersection_point: PointF.new
        }
      end

      reciprocal = 1.0 / denominator
      na = (b.y * c.x - b.x * c.y) * reciprocal
      i_point = @p1 + a * na

      if na < 0 || na > 1
        return {
          type: LineIntersectionType::Unbounded,
          intersection_point: i_point
        }
      end

      nb = (a.x * c.y - a.y * c.x) * reciprocal
      if nb < 0 || nb > 1
        return {
          type: LineIntersectionType::Unbounded,
          intersection_point: i_point
        }
      end

      return {
        type: LineIntersectionType::Bounded,
        intersection_point: i_point
      }
    end

    def angle(l : LineF)
      return 0.0 if self.null? || l.null?
      cos_line = (self.dx * l.dx + self.dy * l.dy) / (self.length * l.length)
      rad = 0
      rad = Math.cos(cos_line) if cos_line >= -1.0 && cos_line <= 1.0
      rad * 360.0 / PI2;
    end

    @[AlwaysInline]
    def point_at(t : Float64)
      PointF.new(@p1.x + (@p2.x - @p1.x) * t, @p1.y + (@p2.y - @p1.y) * t)
    end

    @[AlwaysInline]
    def translate(p : PointF)
      @p1 += p
      @p2 += p
      self
    end

    @[AlwaysInline]
    def translate(x, y)
      self.translate PointF.new(x, y)
    end

    @[AlwaysInline]
    def translated(p : PointF)
      Point.new(@p1 + p, @p2 + p)
    end

    @[AlwaysInline]
    def translated(dx, dy)
      self.translated Point.new(dx, dy)
    end

    @[AlwaysInline]
    def center
      PointF.new(0.5 * @p1.x + 0.5 * @p2.x, 0.5 * @p1.y + 0.5 * @p2.y)
    end

    @[AlwaysInline]
    def to_line
      Line.new @p1.to_point, @p2.to_point
    end
  end
end
