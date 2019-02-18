require "./color"

module Ltk
  class Palette
    property window : Color
    property text : Color

    def initialize(@window : Color,
                   @text : Color)
    end

    DARK = Palette.new(
      window: Color.new(0xff4e4e4e_u32),
      text: Color.new(0xffc1bfbf_u32)
    )
  end
end
