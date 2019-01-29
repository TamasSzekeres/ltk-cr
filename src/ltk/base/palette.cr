require "./brush"

module Ltk
  class Palette
    property window : Brush

    def initialize(@window : Brush)
    end

    DARK = Palette.new(
      window: Color.new(0x4e4e4e_u32).as(Brush)
    )
  end
end