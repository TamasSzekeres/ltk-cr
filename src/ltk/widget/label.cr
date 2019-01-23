require "x11"

require "../base/painter"
require "../enums/alignment"
require "./widget"

module Ltk
  class Label < Widget
    getter alignment : Alignment = Alignment::Left | Alignment::VCenter
    getter text : String = ""
    property associated_widget : Widget? = nil

    def initialize(parent = nil)
      super parent
    end

    def initialize(@text : String, parent = nil)
      super parent
    end

    protected def paint_event
      p = Painter.new self
      p.draw_label self
    end

    def text=(@text : String)
      repaint
    end

    def has_associated_widget? : Bool
      !@associated_widget.is_a?(Nil)
    end
  end
end