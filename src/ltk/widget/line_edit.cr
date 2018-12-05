require "x11"

require "./widget"

module Ltk
  class LineEdit < Widget

    def initialize(parent = nil)
      super parent
      cursor = display.create_font_cursor(X11::C::XC_XTERM.to_u32)
      display.define_cursor(window, cursor)
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

    protected def mouse_down_event(event : MouseEvent)
      super
      repaint
    end

    protected def mouse_up_event(event : MouseEvent)
      super
      repaint

      r = geometry
      r.x = 0; r.y = 0
      self.click_event if r.contains? event.pos
    end

    protected def paint_event
      p = Painter.new self
      p.draw_line_edit self
      p.finalize
    end

    def text=(@text)
      self.repaint
    end
  end
end
