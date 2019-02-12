require "../enum/check_state"
require "./widget"

module Ltk
  class CheckBox < Widget
    getter text : String
    getter state : CheckState = CheckState::Unchecked
    property tri_state : Bool = false

    getter? hover : Bool = false
    getter? down : Bool = false

    delegate unchecked?, partially_checked?, checked?, to: @state

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

    protected def key_press_event(event : KeyEvent)
      super
      if event.key_sym == 32_u64
        @down = true
        repaint
      end
    end

    protected def key_release_event(event : KeyEvent)
      super
      if @down && (event.key_sym == 32_u64)
        @down = false
        repaint
        click_event
      end
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
      style.draw_checkbox p, self
    end

    def text=(@text)
      self.repaint
    end

    def state=(state : CheckState)
      if @state != state
        @state = state
        repaint
      end
    end

    def uncheck!
      if @state != CheckState::Unchecked
        @state = CheckState::Unchecked
        repaint
      end
    end

    def check_partially!
      if @state != CheckState::PartiallyChecked
        @state = CheckState::PartiallyChecked
        repaint
      end
    end

    def check!
      if @state != CheckState::Checked
        @state = CheckState::Checked
        repaint
      end
    end

    def preferred_size : Size
      Size.new(
        Math.max(minimum_width, @text.size * 8 + 20),
        Math.max(minimum_width, 23))
    end
  end
end