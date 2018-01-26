module Ltk
  struct Margins
    property left : Int32
    property top : Int32
    property right : Int32
    property bottom : Int32

    def initialize
      @left = 0
      @top = 0
      @right = 0
      @bottom = 0
    end

    def initialize(@left : Int32, @top : Int32, @right : Int32, @bottom : Int32)
    end

    @[AlwaysInline]
    def null? : Bool
      @left == 0 && @top == 0 && @right == 0 && @bottom == 0
    end

    @[AlwaysInline]
    def +(m : Margins)
      Margins.new(@left + m.left, @top + m.top, @right + m.right, @bottom + m.bottom)
    end

    @[AlwaysInline]
    def -(m : Margins)
      Margins.new(@left - m.left, @top - m.top, @right - m.right, @bottom - m.bottom)
    end

    @[AlwaysInline]
    def +(x : Int32)
      Margins.new(@left + x, @top + x, @right + x, @bottom + x)
    end

    @[AlwaysInline]
    def -(x : Int32)
      Margins.new(@left - x, @top - x, @right - x, @bottom - x)
    end

    @[AlwaysInline]
    def *(factor : Int32)
      Margins.new(@left * factor, @top * factor, @right * factor, @bottom * factor)
    end

    @[AlwaysInline]
    def *(factor : Float)
      Margins.new((@left * factor).round.to_i, (@top * factor).round.to_i,
                  (@right * factor).round.to_i, (@bottom * factor).round.to_i)
    end

    @[AlwaysInline]
    def /(divisor : Int32)
      Margins.new(@left / divisor, @top / divisor, @right / divisor, @bottom / divisor)
    end

    @[AlwaysInline]
    def /(divisor : Float)
      Margins.new((@left / divisor).round.to_i, (@top / divisor).round.to_i,
                  (@right / divisor).round.to_i, (@bottom / divisor).round.to_i)
    end
  end
end