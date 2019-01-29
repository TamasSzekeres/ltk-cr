module Ltk
  # 0xAARRGGBB
  alias Rgb = UInt32

  struct Color
    property red : UInt8
    property green : UInt8
    property blue : UInt8
    property alpha : UInt8

    def initialize
      @red = 0_u8
      @green = 0_u8
      @blue = 0_u8
      @alpha = UInt8::MAX
    end

    def initialize(@red : UInt8, @green : UInt8, @blue : UInt8, @alpha = UInt8::MAX)
    end

    def initialize(red : Int32, green : Int32, blue : Int32, alpha : Int32 = 0xff)
      @red = red.to_u8
      @green = green.to_u8
      @blue = blue.to_u8
      @alpha = alpha.to_u8
    end

    def initialize(rgb : Rgb)
      @red   = ((rgb >> 16) & 0x000000ff_u32).to_u8
      @green = ((rgb >>  8) & 0x000000ff_u32).to_u8
      @blue  = (rgb & 0x000000ff_u32).to_u8
      @alpha = ((rgb >> 24) & 0x000000ff_u32).to_u8
    end

    #def initialize(name)
    #end

    def name
    end

    def darker(factor = 150)
    end

    def lighter(factor = 150)
    end

    def to_rgb : Rgb
    end

    def to_cmyk : ColorCmyk
    end

    def to_hsl : ColorHsl
    end

    def to_hsv : ColorHsv
    end

    def self.from_cmyk(c : UInt8, m : UInt8, y : UInt8, k : UInt8, a = UInt8::MAX)
    end

    def self.from_hsl(h : UInt8, s : UInt8, l : UInt8, a = UInt8::MAX)
    end

    def self.from_hsv(h : UInt8, s : UInt8, v : UInt8, a = UInt8::MAX)
    end

    WHITE        = Color.new 0xff, 0xff, 0xff
    BLACK        = Color.new 0x00, 0x00, 0x00
    RED          = Color.new 0xff, 0x00, 0x00
    DARK_RED     = Color.new 0x80, 0x00, 0x00
    GREEN        = Color.new 0x00, 0xff, 0x00
    DARK_GREEN   = Color.new 0x00, 0x80, 0x00
    BLUE         = Color.new 0x00, 0x00, 0xff
    DARK_BLUE    = Color.new 0x00, 0x00, 0x80
    CYAN         = Color.new 0x00, 0xff, 0xff
    DARK_CYAN    = Color.new 0x00, 0x80, 0x80
    MAGENTA      = Color.new 0xff, 0x00, 0xff
    DARK_MAGENTA = Color.new 0x80, 0x00, 0x80
    YELLOW       = Color.new 0xff, 0xff, 0x00
    DARK_YELLOW  = Color.new 0x80, 0x80, 0x00
    GRAY         = Color.new 0xa0, 0xa0, 0xa4
    DARK_GRAY    = Color.new 0x80, 0x80, 0x80
    LIGHT_GRAY   = Color.new 0xc0, 0xc0, 0xc0
    TRANSPARENT  = Color.new 0x00, 0x00, 0x00, 0x00
  end

  struct ColorCmyk
    property cyan : UInt8
    property magenta : UInt8
    property yellow : UInt8
    property black : UInt8

    def initialize(@cyan, @magenta, @yellow, @black)
    end
  end

  struct ColorHsl
    property hue : UInt8
    property saturation : UInt8
    property lightness : UInt8

    def initialize(@hue, @saturation, @lightness)
    end
  end

  struct ColorHsv
    property hue : UInt8
    property saturation : UInt8
    property value : UInt8

    def initialize(@hue, @saturation, @value)
    end
  end
end
