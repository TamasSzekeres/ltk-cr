require "./color"
require "./gradient"
require "./linear_gradient"

module Ltk
  enum BrushStyle
    NoStyle = 0
    SolidPattern
    LinearGradientPattern
  end

  class Brush
    getter style : BrushStyle

    def initialize
      @style = BrushStyle::NoStyle
    end
  end
end
