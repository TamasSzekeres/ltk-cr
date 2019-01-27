require "x11"

require "./widget"

module Ltk
  class LineEdit < Widget
    getter text = ""
    getter? cursor_visible : Bool = false
    getter cursor_position : Int32 = 0
    getter text_translate = Point::ZERO
    getter cursor_rect : Rect = Rect.new(0, 0, 1, 10)

    def initialize(parent = nil)
      super parent
      cursor = display.create_font_cursor(X11::C::XC_XTERM.to_u32)
      display.define_cursor(window, cursor)

      @cursor_visible = false
      @timer = Timer.new(500.milliseconds) do |timer|
        @cursor_visible = !@cursor_visible
        repaint
      end
    end

    protected def focus_received_event
      super
      @timer.start
    end

    protected def focus_lost_event
      super
      @cursor_visible = false
      @timer.stop
      repaint
    end

    protected def click_event
      super
    end

    protected def enter_event
      super
      repaint
    end

    protected def leave_event
      super
      repaint
    end

    protected def key_press_event(event : KeyEvent)
      super
      case event.key_sym
        when X11::C::XK_Home, X11::C::XK_KP_Home
          move_cursor_home
          return
        when X11::C::XK_End, X11::C::XK_KP_End
          move_cursor_end
          return
        when X11::C::XK_Left, X11::C::XK_KP_Left
          move_cursor_left
          return
        when X11::C::XK_Right, X11::C::XK_KP_Right
          move_cursor_right
          return
        when X11::C::XK_BackSpace
          delete_left
          return
        when X11::C::XK_Delete
          delete_right
          return
      end
      key_char = event.key_char
      unless key_char == ::Char::ZERO
        @text = @text.insert @cursor_position, key_char
        @cursor_position += 1
        recalc_cursor
        repaint
      end
    end

    protected def mouse_down_event(event : MouseEvent)
      super
      repaint
    end

    protected def mouse_up_event(event : MouseEvent)
      super
      repaint

      r = geometry
      r.x = 0; r.y = 0
      click_event if r.contains? event.pos
    end

    protected def paint_event
      widget_painter.draw
    end

    private def painter
      @painter ||= Painter.new self
    end

    private def widget_painter
      @widget_painter ||= LineEditPainter.new self, painter
    end

    protected def recalc_cursor
      w = width
      h = height
      right_bound = w - 5

      text_extents = painter.text_extents @text
      text_width = text_extents.width
      text_left = @text[0...@cursor_position]
      text_extents = painter.text_extents text_left
      @cursor_rect = Rect.new((5.5_f64 + text_extents.width + @text_translate.x).round.to_i, 5, 1, h - 10)

      #puts "recalc_cursor w=#{w} cp=#{@cursor_position}"
      #puts "left=#{text_left} w=#{text_extents.width}"
      if @cursor_rect.x > right_bound
        @text_translate.x = right_bound - text_extents.width.round.to_i - 5
        @cursor_rect.x = right_bound
        @cursor_rect.width = 1
      else
        if @text_translate.x < 0
          @cursor_rect.x = right_bound
          @text_translate.x = right_bound - text_extents.width.to_i - 5
          if @text_translate.x > 0
            @cursor_rect.x = @cursor_rect.x - @text_translate.x
            @text_translate.x = 0
          end
          @cursor_rect.width = 1
        end
      end
      #puts "new cursor x=#{@cursor_rect.x}"
      #puts "text_translate.x = #{@text_translate.x}"
    end

    private def move_cursor_home
      if @cursor_position != 0
        @cursor_position = 0
        @cursor_visible = true
        recalc_cursor
        repaint
      end
    end

    private def move_cursor_end
      size = @text.size
      if @cursor_position != size
        @cursor_position = size
        @cursor_visible = true
        recalc_cursor
        repaint
      end
    end

    private def move_cursor_left
      if @cursor_position > 0
        @cursor_position -= 1
        @cursor_visible = true
        recalc_cursor
        repaint
      end
    end

    private def move_cursor_right
      if @cursor_position < @text.size
        @cursor_position += 1
        @cursor_visible = true
        recalc_cursor
        repaint
      end
    end

    private def delete_left
      if @cursor_position > 0
        @text = @text[0...(@cursor_position - 1)] + @text[@cursor_position..-1]
        @cursor_position -= 1
        @cursor_visible = true
        recalc_cursor
        repaint
      end
    end

    private def delete_right
      size = @text.size
      if size > @cursor_position
        @text = @text[0...@cursor_position] + @text[(@cursor_position + 1)..-1]
        @cursor_visible = true
        recalc_cursor
        repaint
      end
    end

    def text=(@text : String)
      @cursor_position = @text.size
      recalc_cursor
      repaint
    end

    def cursor_position=(pos : Int32)
      if pos < 0
        pos = 0
      elsif pos >= @text.size
        pos = @text.size - 1
      end
      return if @cursor_position == pos
      @cursor_position = pos
      recalc_cursor
      repaint
    end
  end
end
