require "x11"
require "cairo"

require "../widget/push_button"

module Ltk
  include X11
  include Cairo

  struct Painter
    def initialize(widget : Widget)
      @brush = Color::WHITE

      @surface = Cairo::XlibSurface.new(
        widget.display, widget.window,
        widget.display.default_visual(widget.screen.screen_number),
        widget.width, widget.height
      )
      @ctx = Cairo::Context.new @surface
      # @pattern = nil
    end

    # def finalize
      # Cairo.destroy @ctx
      # Cairo.surface_destroy @surface
      #
      # Cairo.pattern_destroy @pattern unless @pattern == nil
    # end

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
      #@ctx.set_source_rgb 0.8_f64, 0.8_f64, 0.8_f64
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

    def draw_push_button(button : PushButton, hover : Bool, down : Bool)
      w = button.width
      h = button.height

      @ctx.set_source_rgb 0.3_f64, 0.3_f64, 0.3_f64
      @ctx.rectangle 0.0_f64, 0.0_f64, w.to_f, h.to_f
      @ctx.fill

      # @ctx.scale 3.0_f64, 3.0_f64

      pattern = Pattern.create_linear 0.0_f64, 0.0_f64, 0.0_f64, h.to_f
      if down
        pattern.add_color_stop 0.0_f64, 46.0_f64 / 255.0_f64, 46.0_f64 / 255.0_f64, 46.0_f64 / 255.0_f64
        pattern.add_color_stop 1.0_f64, 60.0_f64 / 255.0_f64, 60.0_f64 / 255.0_f64, 60.0_f64 / 255.0_f64
      else
        pattern.add_color_stop 0.0_f64, 0.25_f64, 0.25_f64, 0.25_f64
        pattern.add_color_stop 1.0_f64, 0.18_f64, 0.18_f64, 0.18_f64
      end
      @ctx.source = pattern
      fill_round_rect 0, 0, w, h, 3

      w -= 2; h -= 2
      pattern = Pattern.create_linear 0.0_f64, 0.0_f64, 0.0_f64, h.to_f
      if down
        pattern.add_color_stop 0.0_f64, 63.0_f64 / 255.0_f64, 63.0_f64 / 255.0_f64, 63.0_f64 / 255.0_f64
        pattern.add_color_stop 1.0_f64, 62.0_f64 / 255.0_f64, 62.0_f64 / 255.0_f64, 62.0_f64 / 255.0_f64
      else
        pattern.add_color_stop 0.0_f64, 0.44_f64, 0.44_f64, 0.44_f64
        pattern.add_color_stop 1.0_f64, 0.35_f64, 0.35_f64, 0.35_f64
      end
      @ctx.source = pattern
      fill_round_rect 1, 1, w, h, 3

      w -= 2; h -= 2
      pattern = Pattern.create_linear 0.0_f64, 0.0_f64, 0.0_f64, h.to_f
      if down
        pattern.add_color_stop 0.0_f64, 71.0_f64 / 255.0_f64, 71.0_f64 / 255.0_f64, 71.0_f64 / 255.0_f64
        pattern.add_color_stop 1.0_f64, 65.0_f64 / 255.0_f64, 65.0_f64 / 255.0_f64, 65.0_f64 / 255.0_f64
      else
        c1 = hover ? 0.45_f64 : 0.40_f64
        c2 = hover ? 0.36_f64 : 0.33_f64
        pattern.add_color_stop 0.0_f64, c1, c1, c1
        pattern.add_color_stop 1.0_f64, c2, c2, c2
      end
      @ctx.source = pattern
      fill_round_rect 2, 2, w, h, 3

      # Draw Text
      text = button.text

      @ctx.select_font_face("Sans",
        Cairo::FontSlant::Normal,
        Cairo::FontWeight::Normal)
      @ctx.font_size = 12.0_f64

      extents = @ctx.text_extents text
      x = (button.width / 2.0_f64) - (extents.width / 2 + extents.x_bearing)
      y = (button.height / 2.0_f64) - (extents.height / 2 + extents.y_bearing)

      @ctx.move_to x, y

      @ctx.set_source_rgb 0.85_f64, 0.85_f64, 0.85_f64
      @ctx.show_text text
    end

    def draw_line_edit(line_edit : LineEdit)
      w = line_edit.width
      h = line_edit.height

      #@ctx.scale 3.0_f64, 3.0_f64

      # Draw Borders
      pattern = Pattern.create_linear 0.0_f64, 0.0_f64, 0.0_f64, h.to_f
      pattern.add_color_stop 0.0_f64, 46.0_f64 / 255.0_f64, 46.0_f64 / 255.0_f64, 46.0_f64 / 255.0_f64
      pattern.add_color_stop 1.0_f64, 60.0_f64 / 255.0_f64, 60.0_f64 / 255.0_f64, 60.0_f64 / 255.0_f64
      @ctx.source = pattern
      fill_round_rect 0, 0, w, h, 3

      w -= 2; h -= 2
      pattern = Pattern.create_linear 0.0_f64, 0.0_f64, 0.0_f64, h.to_f
      pattern.add_color_stop 0.0_f64, 50.0_f64 / 255.0_f64, 50.0_f64 / 255.0_f64, 50.0_f64 / 255.0_f64
      pattern.add_color_stop 1.0_f64, 53.0_f64 / 255.0_f64, 53.0_f64 / 255.0_f64, 53.0_f64 / 255.0_f64
      @ctx.source = pattern
      fill_round_rect 1, 1, w, h, 3

      w -= 2; h -= 2
      @ctx.set_source_rgb 56.0_f64 / 255.0_f64, 56.0_f64 / 255.0_f64, 56.0_f64 / 255.0_f64
      fill_round_rect 2, 2, w, h, 3

      # Draw Text
      text = line_edit.text

      @ctx.select_font_face("Sans",
        Cairo::FontSlant::Normal,
        Cairo::FontWeight::Normal)
      @ctx.font_size = 12.0_f64

      extents = @ctx.text_extents text
      x = 10.0_f64
      y = (line_edit.height / 2.0_f64) - (extents.height / 2 + extents.y_bearing)

      @ctx.move_to x, y

      @ctx.set_source_rgb 0.85_f64, 0.85_f64, 0.85_f64
      @ctx.show_text text

      # Draw Cursor
      if line_edit.cursor_visible?
        x = 10.0_f64
        @ctx.set_source_rgb 1.0_f64, 1.0_f64, 1.0_f64
        @ctx.move_to x, 0.0_f64
        @ctx.line_to x, 22.0_f64
        @ctx.line_width = 1.0
        @ctx.stroke
      end
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
  end # class Painter
end # module Ltk
