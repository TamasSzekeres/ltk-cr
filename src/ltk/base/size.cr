require "../enums/aspect_ratio_mode"

module Ltk
  struct Size
    ZERO = Size.new(0, 0)
    MAX = Size.new(Int32::MAX, Int32::MAX)

    property width : Int32
    property height : Int32

    def initialize
      @width = -1
      @height = -1
    end

    def initialize(@width, @height)
    end

    @[AlwaysInline]
    def null? : Bool
      @width == 0 && @height == 0
    end

    @[AlwaysInline]
    def empty? : Bool
      @width < 1 || @height < 1
    end

    @[AlwaysInline]
    def valid? : Bool
      @width >= 0 && @height >= 0
    end

    @[AlwaysInline]
    def transpose : Size
      @width, @height = @height, @width
      self
    end

    @[AlwaysInline]
    def transposed : Size
      Size.new @height, @width
    end

    @[AlwaysInline]
    def scale(w : Int, h : Int, mode : AspectRatioMode) : Size
      scale Size.new(w, h), mode
    end

    @[AlwaysInline]
    def scale(s : Size, mode : AspectRatioMode) : Size
      s = scaled s, mode
      @width, @height = s.width, s.height
      self
    end

    @[AlwaysInline]
    def scaled(w : Int, h : Int, mode : AspectRatioMode) : Size
      self.scaled Size.new(w, h), mode
    end

    def scaled(s : Size, mode : AspectRatioMode) :  Size
      if mode == AspectRatioMode::Ignore || @width == 0 || @height == 0
        return s
      end

      use_height = false
      rw = s.height * @width / @height

      if mode == AspectRatioMode::Keep
        use_height = rw <= s.width
      else # mode == AspectRatioMode::KeepByExpanding
          use_height = rw >= s.width
      end

      if use_height
        Size.new rw, s.height
      else
        Size.new s.width, s.width * @height / @width
      end
    end

    @[AlwaysInline]
    def expanded_to(other : Size) : Size
      Size.new(
        Math.max(@width, other.width),
        Math.max(@height, other.height))
    end

    @[AlwaysInline]
    def bounded_to(other : Size) : Size
      Size.new(
        Math.min(@width, other.width),
        Math.min(@height, other.height))
    end

    @[AlwaysInline]
    def +(s : Size) : Size
      Size.new @width + s.width, @height + s.height
    end

    @[AlwaysInline]
    def -(s : Size) : Size
      Size.new @width - s.width, @height - s.height
    end

    @[AlwaysInline]
    def *(c : Float) : Size
      Size.new (@width * c).round.to_i, (@height * c).round.to_i
    end

    @[AlwaysInline]
    def /(s : Float) : Size
      Size.new (@width / c).round.to_i, (@height / c).round.to_i
    end

    def to_s(io)
      io << @width << @height
    end
  end

  struct Float
    @[AlwaysInline]
    def *(s : Size) : Size
      Size.new (s.width * self).round.to_i, (s.height * self).round.to_i
    end
  end
end
