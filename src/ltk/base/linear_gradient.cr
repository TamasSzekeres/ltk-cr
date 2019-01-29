require "./gradient"
require "./point"

module Ltk
  struct LinearGradient < Gradient
    property start : PointF
    property end : PointF

    def initialize(@start : PointF, @end : PointF)
      super
    end

    def initialize(x0 : Float64, y0 : Float64, x1 : Float64, y1 : Float64)
      super
      @start = PointF.new x0, y0
      @end = PointF.new x1, y1
    end
  end
end
