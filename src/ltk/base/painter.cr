require "x11"
require "cairo"

require "../widget/*"

module Ltk
  include X11
  include Cairo

  struct Painter
    getter brush : Brush = Color::WHITE.as(Brush)
    getter font_extents : Cairo::FontExtents
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

      apply_pen(@pen)
    end

    # def finalize
      # Cairo.destroy @ctx
      # Cairo.surface_destroy @surface
      #
      # Cairo.pattern_destroy @pattern unless @pattern == nil
    # end

    def draw_line(x0 : Int32, y0 : Int32, x1 : Int32, y1 : Int32)
      # puts "draw line r=#{@pen.color.red} w=#{@pen.width}"
      # puts "ctx.line_width = #{@ctx.line_width}"

      @ctx.move_to(x0.to_f, y0.to_f)
      @ctx.line_to(x1.to_f, y1.to_f)
      @ctx.stroke
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
      apply_pen(@pen)
    end

    def pen=(color : Color)
      @pen = Pen.new(color)
      apply_pen(@pen)
    end

    private def apply_brush
      # unless @pattern.is_a? Nil
      #   Cairo.pattern_destroy @pattern
      #   @pattern = nil
      # end
      #
      # case @brush
      # when Color
      #   col = brush.as Color
      #   mul = 1.0_f64 / 255.0_f64
      #   Cairo.set_source_rgba(@ctx,
      #     col.red * mul, col.green * mul, col.blue * mul, col.alpha * mul)
      # when LinearGradient
      #   lg = @brush.as LinearGradient
      #   s = lg.start
      #   e = lg.end
      #   @pattern = Cairo.pattern_create_linear(s.x, s.y, e.x, e.y)
      #
      #   lg.stops.each do |stop|
      #     Cairo.pattern_add_color_stop_rgba(
      #       @pattern, stop.offset, stop.red,
      #       stop.green, stop.blue, stop.alpha)
      #   end
      #   Cairo.set_source @ctx, @pattern
      # else
      # end
    end

    private def apply_pen(pen : Pen)
      color = pen.color
      mul = 1.0_f64 / 255.0_f64
      @ctx.set_source_rgba(color.red * mul, color.green * mul, color.blue * mul, color.alpha * mul)
      @ctx.line_width = pen.width
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
