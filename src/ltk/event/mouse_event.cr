require "./event"
require "./event_button"
require "../base/point"

module Ltk
  class MouseEvent < Event
    getter button : EventButton
    getter pos : Point
    getter global_pos : Point

    def initialize(@button, x, y)
      @pos = Point.new x, y
      @global_pos = Point.new x, y
    end

    def initialize(@button, @pos, @global_pos)
    end

    def x
      @pos.x
    end

    def y
      @pos.y
    end

    def global_x
      @global_pos.x
    end

    def global_y
      @global_pos.y
    end
  end
end
