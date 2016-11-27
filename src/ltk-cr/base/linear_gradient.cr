require "./gradient"
require "./point"

module Ltk
  class LinearGradient < Gradient
    property start : PointF
    property end : PointF

    def initialize(@start, @end)
      super
    end

    def initialize(x0, y0, x1, y1)
      super
      @start = PointF.new x0, y0
      @end = PointF.new x1, y1
    end
  end
end
