require "./color"

module Ltk
  struct GradientStop
    property offset : Float64
    property red : Float64
    property green : Float64
    property blue : Float64
    property alpha : Float64

    def initialize(@offset, @red, @green, @blue, @alpha = 1.0_f64)
    end

    def initialize(@offset, color : Color)
      mul = 1.0_f64 / 255.0_f64
      @red = color.red * mul
      @green = color.green * mul
      @blue = color.blue * mul
      @alpha = color.alpha * mul
    end
  end

  class Gradient
    getter stops : Array(GradientStop)

    def initialize
      @stops = Array(GradientStop).new
    end

    def add_color_stop(offset, red, green, blue, alpha = 1.0_f64)
      @stops << GradientStop.new offset, red, green, blue, alpha
    end

    def add_color_stop(offset, color)
      @stops << GradientStop.new offset, color
    end
  end
end
