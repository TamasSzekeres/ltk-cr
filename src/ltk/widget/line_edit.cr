require "x11"

require "./widget"

module Ltk
  class LineEdit < Widget
    getter text = ""
    getter? cursor_visible : Bool = false
    getter cursor_position : Int32 = 0

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
        @text += key_char
        @cursor_position += 1
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
      p = Painter.new self
      p.draw_line_edit self
    end

    private def move_cursor_home
      if @cursor_position != 0
        @cursor_position = 0
        @cursor_visible = true
        repaint
      end
    end

    private def move_cursor_end
      size = @text.size
      if @cursor_position != size
        @cursor_position = size
        @cursor_visible = true
        repaint
      end
    end

    private def move_cursor_left
      if @cursor_position > 0
        @cursor_position -= 1
        @cursor_visible = true
        repaint
      end
    end

    private def move_cursor_right
      if @cursor_position < @text.size
        @cursor_position += 1
        @cursor_visible = true
        repaint
      end
    end

    private def delete_left
      if @cursor_position > 0
        @text = @text[0...(@cursor_position - 1)] + @text[@cursor_position..-1]
        @cursor_position -= 1
        @cursor_visible = true
        repaint
      end
    end

    private def delete_right
      size = @text.size
      if size > @cursor_position
        @text = @text[0...@cursor_position] + @text[(@cursor_position + 1)..-1]
        @cursor_visible = true
        repaint
      end
    end

    def text=(@text : String)
      @cursor_position = @text.size
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
      repaint
    end
  end
end
