require "../enums/keyboard_modifiers"
require "./event"

module Ltk
  abstract struct InputEvent < Event
    getter modifiers : KeyboardModifiers

    def initialize(@modifiers : KeyboardModifiers)
    end
  end
end
