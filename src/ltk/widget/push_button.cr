require "x11"

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
      super parent
    end

    protected def click_event
      super
    end

    protected def enter_event
      super
      @hover = true
      repaint
    end

    protected def leave_event
      super
      @hover = false
      repaint
    end

    protected def mouse_down_event(event : MouseEvent)
      super
      @down = true
      repaint
    end

    protected def mouse_up_event(event : MouseEvent)
      super
      @down = false
      repaint

      r = geometry
      r.x = 0; r.y = 0
      self.click_event if r.contains? event.pos
    end

    protected def paint_event
      p = Painter.new self
      p.draw_push_button self, @hover, @down
      p.finalize
    end

    def text=(@text)
      self.repaint
    end
  end
end
