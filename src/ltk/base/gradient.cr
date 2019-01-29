require "./color"

module Ltk
  struct GradientStop
    property offset : Float64
    property red : Float64
    property green : Float64
    property blue : Float64
    property alpha : Float64

    def initialize(@offset : Float64, @red : Float64, @green : Float64, @blue : Float64, @alpha : Float64 = 1.0_f64)
    end

    def initialize(@offset : Float64, color : Color)
      mul = 1.0_f64 / 255.0_f64
      @red = color.red * mul
      @green = color.green * mul
      @blue = color.blue * mul
      @alpha = color.alpha * mul
    end
  end

  abstract struct Gradient
    getter stops : Array(GradientStop)

    def initialize
      @stops = Array(GradientStop).new
    end

    def add_color_stop(offset : Float64, red : Float64, green : Float64, blue : Float64, alpha : Float64 = 1.0_f64)
      @stops << GradientStop.new offset, red, green, blue, alpha
    end

    def add_color_stop(offset : Float64, color : Color)
      @stops << GradientStop.new offset, color
    end
  end
end
