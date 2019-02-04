require "x11"
require "cairo"

require "../widget/*"

module Ltk
  include X11
  include Cairo

  struct Painter
    getter font_extents : Cairo::FontExtents
    getter brush : Brush = Color::WHITE.as(Brush)
    getter pen : Pen = Pen.new
    private getter space_width : Float64

    def initialize(widget : Widget)
      @surface = Cairo::XlibSurface.new(
        widget.display, widget.window,
        widget.display.default_visual(widget.screen.screen_number),
        widget.width, widget.height
      )
      @ctx = Cairo::Context.new @surface
      # @pattern = nil

      @ctx.select_font_face("Sans",
        Cairo::FontSlant::Normal,
        Cairo::FontWeight::Normal)
      @ctx.font_size = 12.0_f64

      @font_extents = @ctx.font_extents

      @space_width = @ctx.text_extents("a a").width - @ctx.text_extents("aa").width

      apply @brush
      apply @pen
    end

    # def finalize
      # Cairo.destroy @ctx
      # Cairo.surface_destroy @surface
      #
      # Cairo.pattern_destroy @pattern unless @pattern == nil
    # end

    def clear
      @ctx.save
      @ctx.set_source_rgb 1.0, 1.0, 1.0
      @ctx.paint
      @ctx.restore
    end

    def stroke(pen : Pen, &block)
      with_source pen do
        block.call
        @ctx.stroke
      end
    end

    def fill(brush : Brush, &block)
      with_source brush do
        block.call
        @ctx.fill
      end
    end

    def arc(center_x : Float64, center_y : Float64, radius : Float64, start_angle : Float64, end_angle : Float64)
      @ctx.arc(center_x, center_y, radius, start_angle, end_angle)
    end

    def arc(center : PointF, radius : Float64, start_angle : Float64, end_angle : Float64)
      @ctx.arc(center.x, center.y, radius, start_angle, end_angle)
    end

    def arc(x : Float64, y : Float64, width : Float64, height : Float64, start_angle : Float64, end_angle : Float64)
      @ctx.save
      # TODO: implement
      @ctx.restore
    end

    def circle(center_x : Int32, center_y : Int32, radius : Int32)
      @ctx.arc(center_x.to_f, center_y.to_f radius.to_f, 0.0, Math::PI * 2.0)
    end

    def circle(center : Point, radius : Int32)
      @ctx.arc(center.x, center.y, radius.to_f, 0.0, Math::PI * 2.0)
    end

    def circle(center_x : Float64, center_y : Float64, radius : Float64)
      @ctx.arc(center_x, center_y, radius, 0.0, Math::PI * 2.0)
    end

    def circle(center : PointF, radius : Float64)
      @ctx.arc(center.x, center.y, radius, 0.0, Math::PI * 2.0)
    end

    def ellipse(x : Float64, y : Float64, width : Float64, height : Float64)
      sx, sy = 1.0, 1.0
      r = Math.min(width, height) / 2.0
      if width > height
        sx = width / height
      else
        sy = height / width
      end

      @ctx.save
      @ctx.translate(x, y)
      @ctx.scale(sx, sy)
      @ctx.arc(r, r, r, 0.0, Math::PI * 2.0)
      @ctx.restore
    end

    def ellipse(x : Int32, y : Int32, width : Int32, height : Int32)
      ellipse(x.to_f, y.to_f, width.to_f, height.to_f)
    end

    def ellipse(rect : Rect)
      ellipse(rect.x, rect.y, rect.width, rect.height)
    end

    def ellipse(rect : RectF)
      ellipse(rect.x, rect.y, rect.width, rect.height)
    end

    def point(x : Float64, y : Float64)
      rectangle(x, y, 1.0, 1.0)
    end

    def point(x : Int32, y : Int32)
      rectangle(x.to_f, y.to_f, 1.0, 1.0)
    end

    def point(p : PointF)
      point(p.x, p.y)
    end

    def point(p : Point)
      point(p.x.to_f, p.y.to_f)
    end

    def polygon(points : Array(PointF))
      points.each_with_index do |p, i|
        if i == 0
          @ctx.move_to(p.x, p.y)
        else
          @ctx.line_to(p.x, p.y)
        end
      end
      p = points[0]
      @ctx.line_to(p.x, p.y)
    end

    def rectangle(x : Int32, y : Int32, width : Int32, height : Int32)
      @ctx.rectangle(x.to_f, y.to_f, width.to_f, height.to_f)
    end

    def rectangle(rect : Rect)
      @ctx.rectangle(rect.x.to_f, rect.y.to_f, rect.width.to_f, rect.height.to_f)
    end

    def rectangle(x : Float64, y : Float64, width : Float64, height : Float64)
      @ctx.rectangle(x, y, width, height)
    end

    def rectangle(rect : RectF)
      @ctx.rectangle(rect.x, rect.y, rect.width, rect.height)
    end

    def line(x0 : Int32, y0 : Int32, x1 : Int32, y1 : Int32)
      @ctx.move_to(x0.to_f, y0.to_f)
      @ctx.line_to(x1.to_f, y1.to_f)
    end

    def path
      @ctx.new_sub_path
      yield
      @ctx.close_path
    end

    def translate(tx : Float64, ty : Float64)
      @ctx.save
      @ctx.translate(tx, ty)
      yield
      @ctx.restore
    end

    def scale(sx : Float64, sy : Float64)
      @ctx.save
      @ctx.scale(sx, sy)
      yield
      @ctx.restore
    end

    def rotate(angle : Float64)
      @ctx.save
      @ctx.rotate(angle)
      yield
      @ctx.restore
    end

    def draw_round_rect(x : Int32, y : Int32, w : Int32, h : Int32, r : Int32)
      # if r > (h / 2)
      #   r = h / 2
      # end
      #
      # degrees = Math::PI / 180.0_f64
      #
      # @ctx.new_sub_path
      # @ctx.arc x + w - r, y + r,     r, -90 * degrees,   0 * degrees
      # @ctx.arc x + w - r, y + h - r, r,   0 * degrees,  90 * degrees
      # @ctx.arc x + r,     y + h - r, r,  90 * degrees, 180 * degrees
      # @ctx.arc x + r,     y + r,     r, 180 * degrees, 270 * degrees
      # @ctx.close_path
      #
      # @ctx.stroke
    end

    def fill_rectangle(x : Int32, y : Int32, w : Int32, h : Int32)
      @ctx.rectangle x.to_f, y.to_f, w.to_f, h.to_f
      @ctx.fill
    end

    def fill_round_rect(x : Int32, y : Int32, w : Int32, h : Int32, r : Int32)
      if r > (h / 2)
        r = h / 2
      end

      degrees = Math::PI / 180.0_f64

      @ctx.new_sub_path
      @ctx.arc x + w - r, y + r,     r, -90 * degrees,   0 * degrees
      @ctx.arc x + w - r, y + h - r, r,   0 * degrees,  90 * degrees
      @ctx.arc x + r,     y + h - r, r,  90 * degrees, 180 * degrees
      @ctx.arc x + r,     y + r,     r, 180 * degrees, 270 * degrees
      @ctx.close_path

      @ctx.fill
    end

    def pen=(@pen : Pen)
      apply @pen
    end

    def pen=(color : Color)
      @pen = Pen.new(color)
      apply @pen
    end

    private def apply(brush : Brush)
      case brush
      when Color
        col = brush.as Color
        mul = 1.0_f64 / 255.0_f64
        @ctx.set_source_rgba(col.red * mul, col.green * mul, col.blue * mul, col.alpha * mul)
      when LinearGradient
        lg = brush.as LinearGradient
        s = lg.start
        e = lg.end
        pattern = Pattern.create_linear(s.x, s.y, e.x, e.y)
        lg.stops.each do |stop|
          pattern.add_color_stop(stop.offset, stop.red, stop.green, stop.blue, stop.alpha)
        end
        @ctx.source = pattern
      else
        raise "Unknown brush type: #{brush.class}"
      end
    end

    private def apply(pen : Pen)
      color = pen.color
      mul = 1.0_f64 / 255.0_f64
      @ctx.set_source_rgba(color.red * mul, color.green * mul, color.blue * mul, color.alpha * mul)
      @ctx.line_width = pen.width
    end

    private def with_source(brush : Brush)
      @ctx.save
      begin
        case brush
        when Color
          col = brush.as Color
          mul = 1.0_f64 / 255.0_f64
          @ctx.set_source_rgba(col.red * mul, col.green * mul, col.blue * mul, col.alpha * mul)
          yield
        when LinearGradient
          lg = @brush.as LinearGradient
          s = lg.start
          e = lg.end
          pattern = Pattern.create_linear(s.x, s.y, e.x, e.y)
          begin
            lg.stops.each do |stop|
              pattern.add_color_stop(stop.offset, stop.red, stop.green, stop.blue, stop.alpha)
            end
            @ctx.source = pattern
            yield
          ensure
            pattern.finalize
          end
        else
          raise "Unknown brush type: #{brush.class}"
        end
      ensure
        @ctx.restore
      end
    end

    private def with_source(pen : Pen)
      @ctx.save
      begin
        color = pen.color
        mul = 1.0_f64 / 255.0_f64
        @ctx.set_source_rgba(color.red * mul, color.green * mul, color.blue * mul, color.alpha * mul)
        @ctx.line_width = pen.width
        yield
      ensure
        @ctx.restore
      end
    end

    def text_extents(text : String, trailing_ws : Bool = true) : Cairo::TextExtents
      if trailing_ws
        ws_count = text.count(' ')
        if ws_count > 0
          te = @ctx.text_extents text.delete(' ')
          te.width += (ws_count * @space_width)
          return te
        end
      end
      @ctx.text_extents text
    end

    def cairo_context : Cairo::Context
      @ctx
    end
  end # class Painter
end # module Ltk
