require "x11"

require "./widget"

module Ltk
  class LineEdit < Widget
    getter text = ""
    getter? cursor_visible : Bool = false

    def initialize(parent = nil)
      super parent
      cursor = display.create_font_cursor(X11::C::XC_XTERM.to_u32)
      display.define_cursor(window, cursor)

      @cursor_visible = false
      @timer = Timer.new(1.second) do |timer|
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
      key_char = event.key_char
      if key_char.letter?
        if event.modifiers.shift? ^ event.modifiers.lock?
          @text += event.key_char.upcase
        else
          @text += event.key_char
        end
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

    def text=(@text : String)
      repaint
    end
  end
end
