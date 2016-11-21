require "./x11-cr/x11/X"
require "./x11-cr/x11/Xlib"

require "../event/mouse_event"
require "./widget"

module Ltk
  class PushButton < Widget
    getter text : String

    @hover = false
    @down = false

    def initialize(parent = nil)
      super parent
      @text = ""
    end

    def initialize(@text, parent = nil)
      puts "PushButton:initialize text=#{@text}"
      super parent
    end

    protected def click_event
    end

    protected def enter_event
      @hover = true
      repaint
    end

    protected def leave_event
      @hover = false
      repaint
    end

    protected def mouse_down_event(event : MouseEvent)
      @down = true
      repaint
    end

    protected def mouse_up_event(event : MouseEvent)
      @down = false
      repaint
      r = geometry
      r.x = 0; r.y = 0

      click_event if r.contains? event.pos
    end

    protected def paint_event
      p = Painter.new self
      p.draw_push_button self, @hover, @down
      p.finalize
    end
  end
end
