module Ltk
  struct Color
    property red : UInt8
    property green : UInt8
    property blue : UInt8
    property alpha : UInt8

    def initialize(@red : UInt8, @green : UInt8, @blue : UInt8, @alpha = UInt8::MAX)
    end

    BLACK = Color.new 0, 0, 0
    BLUE  = Color.new 0, 0, UInt8::MAX
    GREEN = Color.new 0, UInt8::MAX, 0
    RED   = Color.new UInt8::MAX, 0, 0
    WHITE = Color.new UInt8::MAX, UInt8::MAX, UInt8::MAX
  end
end
