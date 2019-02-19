require "./widget"

module Ltk
  class RadioButton < Widget
    getter text : String
    getter? checked : Bool = false
    getter? down : Bool = false

    def initialize(parent = nil)
      super parent
      @text = ""
    end

    def initialize(@text, parent = nil)
      super parent
    end

    protected def click_event
      check!
      super
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
      style.draw_radio_button p, self
    end

    def text=(@text)
      self.repaint
    end

    def check!
      unless @checked
        uncheck_group
        @checked = true
        repaint
      end
    end

    protected def uncheck_group
      return if parent.is_a?(Nil)

      parent.not_nil!.children.each do |child|
        if (child != self) && child.is_a?(RadioButton)
          child.uncheck!
        else
        end
      end
    end

    def uncheck!
      if @checked
        @checked = false
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
