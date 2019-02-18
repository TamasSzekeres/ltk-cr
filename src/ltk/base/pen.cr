module Ltk
  struct Pen
    property color : Color = Color::BLACK
    property width : Float64 = 1.0_f64
    property line_cap : LineCap = LineCap::Butt
    property line_join : LineJoin = LineJoin::Miter

    def initialize(@color : Color = Color::BLACK, @width : Float64 = 1.0_f64,
      @line_cap : LineCap = LineCap::Butt, @line_join : LineJoin = LineJoin::Miter)
    end
  end
end
