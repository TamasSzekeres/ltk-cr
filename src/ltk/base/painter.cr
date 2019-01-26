require "x11"
require "cairo"

require "../widget/*"

module Ltk
  include X11
  include Cairo

  struct Painter
    getter font_extents : Cairo::FontExtents, ctx : Cairo::Context
    private getter space_width : Float64

    def initialize(widget : Widget)
      @brush = Color::WHITE

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

    def draw_label(label : Label)
      w = label.width
      h = label.height

      # Draw text
      text = label.text

      extents = @ctx.text_extents text
      x = case label.alignment
      when .right? then w - extents.width
      when .h_center? then (w - extents.width) / 2.0_f64
      else
        0.0_f64
      end
      y = case label.alignment
      when .top? then @font_extents.height
      when .bottom? then h.to_f64 - @font_extents.descent
      else
        (h + @font_extents.ascent) / 2.0_f64
      end

      @ctx.move_to x, y

      @ctx.set_source_rgb 0.85_f64, 0.85_f64, 0.85_f64
      @ctx.show_text text
    end

    def draw_push_button(button : PushButton, hover : Bool, down : Bool)
      w = button.width
      h = button.height

      @ctx.set_source_rgb 0.3_f64, 0.3_f64, 0.3_f64
      @ctx.rectangle 0.0_f64, 0.0_f64, w.to_f, h.to_f
      @ctx.fill

      # @ctx.scale 3.0_f64, 3.0_f64

      if button.focused?
        @ctx.set_source_rgb 83.0_f64 / 255.0_f64, 160.0_f64 / 255.0_f64, 237.0_f64 / 255.0_f64
      else
        pattern = Pattern.create_linear 0.0_f64, 0.0_f64, 0.0_f64, h.to_f
        if down
          pattern.add_color_stop 0.0_f64, 46.0_f64 / 255.0_f64, 46.0_f64 / 255.0_f64, 46.0_f64 / 255.0_f64
          pattern.add_color_stop 1.0_f64, 60.0_f64 / 255.0_f64, 60.0_f64 / 255.0_f64, 60.0_f64 / 255.0_f64
        else
          pattern.add_color_stop 0.0_f64, 0.25_f64, 0.25_f64, 0.25_f64
          pattern.add_color_stop 1.0_f64, 0.18_f64, 0.18_f64, 0.18_f64
        end
        @ctx.source = pattern
      end
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
      y = (button.height / 2.0_f64) - (@font_extents.height / 2 - @font_extents.ascent)

      @ctx.move_to x, y

      @ctx.set_source_rgb 0.85_f64, 0.85_f64, 0.85_f64
      @ctx.show_text text
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
  end # class Painter
end # module Ltk
