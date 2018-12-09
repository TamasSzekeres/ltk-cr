require "./input_event"
require "../base/point"
require "../enums/keyboard_modifiers"

module Ltk
  struct KeyEvent < InputEvent
    getter key_code : UInt32
    getter key_sym : UInt64

    def initialize(@key_code : UInt32, @key_sym : UInt64, modifiers : KeyboardModifiers = KeyboardModifiers::None)
      super modifiers
    end

    def key_char
      @key_sym.unsafe_chr
    end
  end
end
