require "x11"

require "./input_event"
require "../base/point"
require "../enums/keyboard_modifiers"

module Ltk
  struct KeyEvent < InputEvent
    getter key_code : UInt32
    getter key_sym : UInt64
    getter key_char : ::Char

    def initialize(@key_code : UInt32, @key_sym : UInt64, @key_char : ::Char, modifiers : KeyboardModifiers = KeyboardModifiers::None)
      super modifiers
    end

    def initialize(key_event : X11::KeyEvent)
      super KeyboardModifiers.new(key_event.state)
      @key_code = key_event.keycode

      ls = key_event.lookup_string
      @key_sym = ls[:keysym]
      @key_char = ls[:string].size > 0 ? ls[:string].at(0) : ::Char::ZERO
    end
  end
end
