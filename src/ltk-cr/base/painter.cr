require "./x11-cr/x11/Xlib"
require "./cairo-cr"

require "../widget/push_button"

module Ltk
  include X11
  include CairoCr

  class Painter
    def initialize(widget : Widget)
      @brush = Color::WHITE

      @surface = Cairo.xlib_surface_create(
        widget.display, widget.window,
        X.default_visual(widget.display, widget.screen),
        widget.width, widget.height
      )
      @ctx = Cairo.create @surface
      @pattern = nil
    end

    def finalize
      Cairo.destroy @ctx
      Cairo.surface_destroy @surface

      Cairo.pattern_destroy @pattern unless @pattern == nil
    end

    def draw_round_rect(x : Int32, y : Int32, w : Int32, h : Int32, r : Int32)
      if r > (h / 2)
        r = h / 2
      end

      degrees = Math::PI / 180.0_f64

      Cairo.new_sub_path @ctx
      Cairo.arc @ctx, x + w - r, y + r,     r, -90 * degrees,   0 * degrees
      Cairo.arc @ctx, x + w - r, y + h - r, r,   0 * degrees,  90 * degrees
      Cairo.arc @ctx, x + r,     y + h - r, r,  90 * degrees, 180 * degrees
      Cairo.arc @ctx, x + r,     y + r,     r, 180 * degrees, 270 * degrees
      Cairo.close_path @ctx

      Cairo.stroke @ctx
    end

    def fill_rectangle(x : Int32, y : Int32, w : Int32, h : Int32)
      #Cairo.set_source_rgb @ctx, 0.8_f64, 0.8_f64, 0.8_f64
      Cairo.rectangle @ctx, x, y, w, h
      Cairo.fill @ctx
    end

    def fill_round_rect(x : Int32, y : Int32, w : Int32, h : Int32, r : Int32)
      if r > (h / 2)
        r = h / 2
      end

      degrees = Math::PI / 180.0_f64

      Cairo.new_sub_path @ctx
      Cairo.arc @ctx, x + w - r, y + r,     r, -90 * degrees,   0 * degrees
      Cairo.arc @ctx, x + w - r, y + h - r, r,   0 * degrees,  90 * degrees
      Cairo.arc @ctx, x + r,     y + h - r, r,  90 * degrees, 180 * degrees
      Cairo.arc @ctx, x + r,     y + r,     r, 180 * degrees, 270 * degrees
      Cairo.close_path @ctx

      Cairo.fill @ctx
    end

    def draw_push_button(button : PushButton, hover : Bool, down : Bool)
      w = button.width
      h = button.height

      Cairo.set_source_rgb @ctx, 0.3_f64, 0.3_f64, 0.3_f64
      Cairo.rectangle @ctx, 0.0_f64, 0.0_f64, w, h
      Cairo.fill @ctx

      #Cairo.scale @ctx, 3.0_f64, 3.0_f64

      pattern = Cairo.pattern_create_linear 0.0_f64, 0.0_f64, 0.0_f64, h
      if down
        Cairo.pattern_add_color_stop_rgb pattern, 0.0_f64, 46.0_f64 / 255.0_f64, 46.0_f64 / 255.0_f64, 46.0_f64 / 255.0_f64
        Cairo.pattern_add_color_stop_rgb pattern, 1.0_f64, 60.0_f64 / 255.0_f64, 60.0_f64 / 255.0_f64, 60.0_f64 / 255.0_f64
      else
        Cairo.pattern_add_color_stop_rgb pattern, 0.0_f64, 0.25_f64, 0.25_f64, 0.25_f64
        Cairo.pattern_add_color_stop_rgb pattern, 1.0_f64, 0.18_f64, 0.18_f64, 0.18_f64
      end
      Cairo.set_source @ctx, pattern
      fill_round_rect 0, 0, w, h, 3
      Cairo.pattern_destroy pattern

      w -= 2; h -= 2
      pattern = Cairo.pattern_create_linear 0.0_f64, 0.0_f64, 0.0_f64, h
      if down
        Cairo.pattern_add_color_stop_rgb pattern, 0.0_f64, 63.0_f64 / 255.0_f64, 63.0_f64 / 255.0_f64, 63.0_f64 / 255.0_f64
        Cairo.pattern_add_color_stop_rgb pattern, 1.0_f64, 62.0_f64 / 255.0_f64, 62.0_f64 / 255.0_f64, 62.0_f64 / 255.0_f64
      else
        Cairo.pattern_add_color_stop_rgb pattern, 0.0_f64, 0.44_f64, 0.44_f64, 0.44_f64
        Cairo.pattern_add_color_stop_rgb pattern, 1.0_f64, 0.35_f64, 0.35_f64, 0.35_f64
      end
      Cairo.set_source @ctx, pattern
      fill_round_rect 1, 1, w, h, 3
      Cairo.pattern_destroy pattern

      w -= 2; h -= 2
      pattern = Cairo.pattern_create_linear 0.0_f64, 0.0_f64, 0.0_f64, h
      if down
        Cairo.pattern_add_color_stop_rgb pattern, 0.0_f64, 71.0_f64 / 255.0_f64, 71.0_f64 / 255.0_f64, 71.0_f64 / 255.0_f64
        Cairo.pattern_add_color_stop_rgb pattern, 1.0_f64, 65.0_f64 / 255.0_f64, 65.0_f64 / 255.0_f64, 65.0_f64 / 255.0_f64
      else
        c1 = hover ? 0.45_f64 : 0.40_f64
        c2 = hover ? 0.36_f64 : 0.33_f64
        Cairo.pattern_add_color_stop_rgb pattern, 0.0_f64, c1, c1, c1
        Cairo.pattern_add_color_stop_rgb pattern, 1.0_f64, c2, c2, c2
      end
      Cairo.set_source @ctx, pattern
      fill_round_rect 2, 2, w, h, 3
      Cairo.pattern_destroy pattern

      # Draw Text
      text = button.text

      Cairo.select_font_face(@ctx, "Sans",
        Cairo::FontSlantT::NORMAL,
        Cairo::FontWeightT::NORMAL)
      Cairo.set_font_size @ctx, 12.0_f64

      extents = uninitialized Cairo::TextExtentsT
      Cairo.text_extents @ctx, text, pointerof(extents)
      x = (button.width / 2.0_f64) - (extents.width / 2 + extents.x_bearing)
      y = (button.height / 2.0_f64) - (extents.height / 2 + extents.y_bearing)

      Cairo.move_to @ctx, x, y

      Cairo.set_source_rgb @ctx, 0.85_f64, 0.85_f64, 0.85_f64
      Cairo.show_text @ctx, text
    end

    private def apply_brush
      unless @pattern.is_a? Nil
        Cairo.pattern_destroy @pattern
        @pattern = nil
      end

      case @brush
      when Color
        col = brush.as Color
        mul = 1.0_f64 / 255.0_f64
        Cairo.set_source_rgba(@ctx,
          col.red * mul, col.green * mul, col.blue * mul, col.alpha * mul)
      when LinearGradient
        lg = @brush.as LinearGradient
        s = lg.start
        e = lg.end
        @pattern = Cairo.pattern_create_linear(s.x, s.y, e.x, e.y)

        lg.stops.each do |stop|
          Cairo.pattern_add_color_stop_rgba(
            @pattern, stop.offset, stop.red,
            stop.green, stop.blue, stop.alpha)
        end
        Cairo.set_source @ctx, @pattern
      else
      end
    end
  end # class Painter
end # module Ltk
