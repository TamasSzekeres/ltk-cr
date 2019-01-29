module Ltk
  struct Pen
    property color : Color = Color::BLACK
    property width : Float64 = 1.0_f64

    def initialize(@color : Color = Color::BLACK, width : Float64 = 1.0_f64)
    end
  end
end