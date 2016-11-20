require "./point_f"

module Ltk
  class LinearGradient
    property start : PointF
    property end : PointF

    def initialize(@start, @end)
      super
    end

    def initialize(x0, y0, x1, y1)
      @start = PointF.new x0, y0
      @end = PointF.new x1, y1
    end
  end
end
