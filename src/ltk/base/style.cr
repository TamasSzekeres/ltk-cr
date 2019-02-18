require "../enums/alignment"
require "../enums/check_state"
require "../enums/font_slant"
require "../enums/font_weight"
require "../enums/line_cap"
require "../enums/line_join"

class Ltk::Style
  DEFAULT_FONT = Font.new("Sans", 12.0_f64, FontSlant::Normal, FontWeight::Normal)

  def initialize
  end

  def default_font : Font
    DEFAULT_FONT
  end

  def checker_rect(p : Painter, checkbox : CheckBox) : Rect
    Rect.aligned(Rect.new(0, 0, checkbox.width, checkbox.height), 15, 15, Alignment::LeftCenter)
  end

  def draw_editor_frame(p : Painter, rect : Rect, focused : Bool = false, down : Bool = false)
    w = rect.width
    h = rect.height
    ctx = p.cairo_context

    # Draw Borders
    if focused
      ctx.set_source_rgb 83.0_f64 / 255.0_f64, 160.0_f64 / 255.0_f64, 237.0_f64 / 255.0_f64
    else
      pattern = Pattern.create_linear 0.0_f64, 0.0_f64, 0.0_f64, h.to_f
      pattern.add_color_stop 0.0_f64, 46.0_f64 / 255.0_f64, 46.0_f64 / 255.0_f64, 46.0_f64 / 255.0_f64
      pattern.add_color_stop 1.0_f64, 60.0_f64 / 255.0_f64, 60.0_f64 / 255.0_f64, 60.0_f64 / 255.0_f64
      ctx.source = pattern
    end
    p.fill_round_rect rect.x, rect.y, w, h, 3

    w -= 2; h -= 2
    if focused
      ctx.set_source_rgb 48.0_f64 / 255.0_f64, 60.0_f64 / 255.0_f64, 72.0_f64 / 255.0_f64
    else
      pattern = Pattern.create_linear 0.0_f64, 0.0_f64, 0.0_f64, h.to_f
      pattern.add_color_stop 0.0_f64, 50.0_f64 / 255.0_f64, 50.0_f64 / 255.0_f64, 50.0_f64 / 255.0_f64
      pattern.add_color_stop 1.0_f64, 53.0_f64 / 255.0_f64, 53.0_f64 / 255.0_f64, 53.0_f64 / 255.0_f64
      ctx.source = pattern
    end
    p.fill_round_rect rect.x + 1, rect.y + 1, w, h, 3

    w -= 2; h -= 2
    if down
      ctx.set_source_rgb 73.0_f64 / 255.0_f64, 73.0_f64 / 255.0_f64, 73.0_f64 / 255.0_f64
    else
      ctx.set_source_rgb 56.0_f64 / 255.0_f64, 56.0_f64 / 255.0_f64, 56.0_f64 / 255.0_f64
    end
    p.fill_round_rect rect.x + 2, rect.y + 2, w, h, 3
  end

  def draw_checker_mark(p : Painter, rect : Rect, color : Color, state : CheckState)
    if state.checked?
      x_mul = 1.0 / 15.0 * rect.width
      y_mul = 1.0 / 15.0 * rect.height

      p.draw(Pen.new(color, 2.0, LineCap::Square, LineJoin::Miter)) do
        p.polyline([
          PointF.new(rect.x + 4.0 * x_mul, rect.y + 7.0 * y_mul),
          PointF.new(rect.x + 6.5 * x_mul, rect.y + 10.5 * y_mul),
          PointF.new(rect.x + 10.0 * x_mul, rect.y + 4.0 * y_mul)
        ])
      end
    elsif state.partially_checked?
      p.fill(color) do
        p.rounded_rectangle(rect.x + 3.0, rect.y + 3.0, rect.width - 6.0, rect.height - 6.0, 1.0)
      end
    end
  end

  def draw_checkbox(p : Painter, checkbox : CheckBox)
    p.clear
    rect = checker_rect(p, checkbox)
    draw_editor_frame(p, rect, checkbox.focused?, checkbox.down?)
    text_rect = RectF.new(20.0, 0.0, checkbox.width - 20.0, checkbox.height.to_f)
    p.fill(checkbox.palette.text) do
      p.text(text_rect, checkbox.text, Alignment::LeftCenter)
    end
    draw_checker_mark(p, rect, checkbox.palette.text, checkbox.state)
  end

  def draw_label(p : Painter, label : Label)
    w = label.width
    h = label.height
    ctx = p.cairo_context

    # Draw text
    text = label.text

    font_extents = p.font_extents
    extents = ctx.text_extents text
    x = case label.alignment
    when .right? then w - extents.width
    when .h_center? then (w - extents.width) / 2.0_f64
    else
      0.0_f64
    end
    y = case label.alignment
    when .top? then font_extents.height
    when .bottom? then h.to_f64 - font_extents.descent
    else
      (h + font_extents.ascent) / 2.0_f64
    end

    ctx.move_to x, y

    ctx.set_source_rgb 0.85_f64, 0.85_f64, 0.85_f64
    ctx.show_text text
  end

  def draw_line_edit(p : Painter, line_edit : LineEdit)
    focused = line_edit.focused?
    w = line_edit.width
    h = line_edit.height
    ctx = p.cairo_context

    # Draw Borders
    if focused
      ctx.set_source_rgb 83.0_f64 / 255.0_f64, 160.0_f64 / 255.0_f64, 237.0_f64 / 255.0_f64
    else
      pattern = Pattern.create_linear 0.0_f64, 0.0_f64, 0.0_f64, h.to_f
      pattern.add_color_stop 0.0_f64, 46.0_f64 / 255.0_f64, 46.0_f64 / 255.0_f64, 46.0_f64 / 255.0_f64
      pattern.add_color_stop 1.0_f64, 60.0_f64 / 255.0_f64, 60.0_f64 / 255.0_f64, 60.0_f64 / 255.0_f64
      ctx.source = pattern
    end
    p.fill_round_rect 0, 0, w, h, 3

    w -= 2; h -= 2
    if focused
      ctx.set_source_rgb 48.0_f64 / 255.0_f64, 60.0_f64 / 255.0_f64, 72.0_f64 / 255.0_f64
    else
      pattern = Pattern.create_linear 0.0_f64, 0.0_f64, 0.0_f64, h.to_f
      pattern.add_color_stop 0.0_f64, 50.0_f64 / 255.0_f64, 50.0_f64 / 255.0_f64, 50.0_f64 / 255.0_f64
      pattern.add_color_stop 1.0_f64, 53.0_f64 / 255.0_f64, 53.0_f64 / 255.0_f64, 53.0_f64 / 255.0_f64
      ctx.source = pattern
    end
    p.fill_round_rect 1, 1, w, h, 3

    w -= 2; h -= 2
    ctx.set_source_rgb 56.0_f64 / 255.0_f64, 56.0_f64 / 255.0_f64, 56.0_f64 / 255.0_f64
    p.fill_round_rect 2, 2, w, h, 3

    # Clip region for text and cursor
    w = line_edit.width
    h = line_edit.height
    ctx.rectangle(5.0_f64, 0_f64, w - 5.0_f64, h.to_f64)
    ctx.clip

    # Draw Text
    text = line_edit.text
    text_translate = line_edit.text_translate

    font_extents = p.font_extents
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
        # Draw Selection
      else
        ctx.move_to rect.x.to_f64, 4.0_f64
        ctx.line_to rect.x.to_f64, h.to_f64
        ctx.line_width = 1.0
        ctx.stroke
      end
    end
  end

  def draw_push_button(p : Painter, button : PushButton)
    down = button.down?
    hover = button.hover?
    w = button.width
    h = button.height
    ctx = p.cairo_context

    ctx.set_source_rgb 0.3_f64, 0.3_f64, 0.3_f64
    ctx.rectangle 0.0_f64, 0.0_f64, w.to_f, h.to_f
    ctx.fill

    # @ctx.scale 3.0_f64, 3.0_f64

    if button.focused?
      ctx.set_source_rgb 83.0_f64 / 255.0_f64, 160.0_f64 / 255.0_f64, 237.0_f64 / 255.0_f64
    else
      pattern = Pattern.create_linear 0.0_f64, 0.0_f64, 0.0_f64, h.to_f
      if down
        pattern.add_color_stop 0.0_f64, 46.0_f64 / 255.0_f64, 46.0_f64 / 255.0_f64, 46.0_f64 / 255.0_f64
        pattern.add_color_stop 1.0_f64, 60.0_f64 / 255.0_f64, 60.0_f64 / 255.0_f64, 60.0_f64 / 255.0_f64
      else
        pattern.add_color_stop 0.0_f64, 0.25_f64, 0.25_f64, 0.25_f64
        pattern.add_color_stop 1.0_f64, 0.18_f64, 0.18_f64, 0.18_f64
      end
      ctx.source = pattern
    end
    p.fill_round_rect 0, 0, w, h, 3

    w -= 2; h -= 2
    pattern = Pattern.create_linear 0.0_f64, 0.0_f64, 0.0_f64, h.to_f
    if down
      pattern.add_color_stop 0.0_f64, 63.0_f64 / 255.0_f64, 63.0_f64 / 255.0_f64, 63.0_f64 / 255.0_f64
      pattern.add_color_stop 1.0_f64, 62.0_f64 / 255.0_f64, 62.0_f64 / 255.0_f64, 62.0_f64 / 255.0_f64
    else
      pattern.add_color_stop 0.0_f64, 0.44_f64, 0.44_f64, 0.44_f64
      pattern.add_color_stop 1.0_f64, 0.35_f64, 0.35_f64, 0.35_f64
    end
    ctx.source = pattern
    p.fill_round_rect 1, 1, w, h, 3

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
    ctx.source = pattern
    p.fill_round_rect 2, 2, w, h, 3

    # Draw Text
    text = button.text

    p.font = button.font

    extents = ctx.text_extents text
    x = (button.width / 2.0_f64) - (extents.width / 2 + extents.x_bearing)
    y = (button.height / 2.0_f64) - (p.font_extents.height / 2 - p.font_extents.ascent)

    ctx.move_to x, y

    ctx.set_source_rgb 0.85_f64, 0.85_f64, 0.85_f64
    ctx.show_text text
  end
end
