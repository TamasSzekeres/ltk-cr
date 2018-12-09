require "../enums/aspect_ratio_mode"

module Ltk
  struct SizeF
    property width : Float64
    property height : Float64

    def initialize
      @width = -1.0
      @height = -1.0
    end

    def initialize(size : Size)
      @width = size.width
      @height = size.height
    end

    def initialize(@width, @height)
    end

    @[AlwaysInline]
    def null?
      @width == 0.0 && @height == 0.0
    end

    @[AlwaysInline]
    def empty?
      @width <= 0.0 || @height <= 0.0
    end

    @[AlwaysInline]
    def valid?
      @width >= 0.0 && @height >= 0.0
    end

    @[AlwaysInline]
    def transpose
      @width, @height = @height, @width
      self
    end

    @[AlwaysInline]
    def transposed
      SizeF.new @height, @width
    end

    @[AlwaysInline]
    def scale(w, h, mode : AspectRatioMode)
      self.scale SizeF.new(w, h), mode
    end

    @[AlwaysInline]
    def scale(s : SizeF, mode : AspectRatioMode)
      s = self.scaled s, mode
      @width, @height = s.width, s.height
      self
    end

    @[AlwaysInline]
    def scaled(w, h, mode : AspectRatioMode)
      self.scaled SizeF.new(q, h), mode
    end

    def scaled(s : SizeF, mode : AspectRatioMode)
      if mode == AspectRatioMode::Ignore || @width == 0.0 || @height == 0.0
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
        SizeF.new rw, s.height
      else
        SizeF.new s.width, s.width * @height / @width
      end
    end

    @[AlwaysInline]
    def expanded_to(other : SizeF)
      SizeF.new(
        Math.max(@width, other.width),
        Math.max(@height, other.height))
    end

    @[AlwaysInline]
    def bounded_to(other : SizeF)
      SizeF.new(
        Math.min(@width, other.width),
        Math.min(@height, other.height))
    end

    @[AlwaysInline]
    def +(s : SizeF)
      SizeF.new @width + s.width, @height + s.height
    end

    @[AlwaysInline]
    def -(s : SizeF)
      SizeF.new @width - s.width, @height - s.height
    end

    @[AlwaysInline]
    def *(c : Float64)
      SizeF.new @width * c, @height * c
    end

    @[AlwaysInline]
    def /(s : Float64)
      SizeF.new @width / c, @height / c
    end

    @[AlwaysInline]
    def to_size
      Size.new @width.round, @height.round
    end

    def to_s(io)
      io << @width << @height
    end
  end
end
