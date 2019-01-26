module Ltk
  class LineEditPainter
    getter line_edit, painter

    delegate ctx, fill_round_rect, font_extents, to: painter

    def initialize(@line_edit : LineEdit, @painter : Painter)
    end

    def draw
      focused = line_edit.focused?
      w = line_edit.width
      h = line_edit.height

      #ctx.scale 3.0_f64, 3.0_f64

      # Draw Borders
      if focused
        ctx.set_source_rgb 83.0_f64 / 255.0_f64, 160.0_f64 / 255.0_f64, 237.0_f64 / 255.0_f64
      else
        pattern = Pattern.create_linear 0.0_f64, 0.0_f64, 0.0_f64, h.to_f
        pattern.add_color_stop 0.0_f64, 46.0_f64 / 255.0_f64, 46.0_f64 / 255.0_f64, 46.0_f64 / 255.0_f64
        pattern.add_color_stop 1.0_f64, 60.0_f64 / 255.0_f64, 60.0_f64 / 255.0_f64, 60.0_f64 / 255.0_f64
        ctx.source = pattern
      end
      fill_round_rect 0, 0, w, h, 3

      w -= 2; h -= 2
      if focused
        ctx.set_source_rgb 48.0_f64 / 255.0_f64, 60.0_f64 / 255.0_f64, 72.0_f64 / 255.0_f64
      else
        pattern = Pattern.create_linear 0.0_f64, 0.0_f64, 0.0_f64, h.to_f
        pattern.add_color_stop 0.0_f64, 50.0_f64 / 255.0_f64, 50.0_f64 / 255.0_f64, 50.0_f64 / 255.0_f64
        pattern.add_color_stop 1.0_f64, 53.0_f64 / 255.0_f64, 53.0_f64 / 255.0_f64, 53.0_f64 / 255.0_f64
        ctx.source = pattern
      end
      fill_round_rect 1, 1, w, h, 3

      w -= 2; h -= 2
      ctx.set_source_rgb 56.0_f64 / 255.0_f64, 56.0_f64 / 255.0_f64, 56.0_f64 / 255.0_f64
      fill_round_rect 2, 2, w, h, 3

      # Clip region for text and cursor
      w = line_edit.width
      h = line_edit.height
      ctx.rectangle(5.0_f64, 0_f64, w - 5.0_f64, h.to_f64)
      ctx.clip

      # Draw Text
      text = line_edit.text
      text_translate = line_edit.text_translate

      extents = ctx.text_extents text
      x = 5.0_f64 + text_translate.x
      y = (line_edit.height / 2.0_f64) - (font_extents.height / 2 - font_extents.ascent) + text_translate.y

      ctx.move_to x, y

      ctx.set_source_rgb 0.85_f64, 0.85_f64, 0.85_f64
      ctx.show_text text

      # Draw Cursor
      if line_edit.cursor_visible? && line_edit.cursor_position >= 0
        extents = ctx.text_extents text[0...line_edit.cursor_position]
        x = 5.5_f64 + extents.width
        ctx.set_source_rgb 1.0_f64, 1.0_f64, 1.0_f64
        rect = line_edit.cursor_rect
        if rect.width > 1
          puts "rect.width > 0 : #{rect.width}"
        else
          ctx.move_to rect.x.to_f64, 4.0_f64
          ctx.line_to rect.x.to_f64, h.to_f64
          ctx.line_width = 1.0
          ctx.stroke
        end
      end
    end
  end
end
