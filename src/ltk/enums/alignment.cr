module Ltk
  @[Flags]
  enum Alignment : UInt32
    None   = 0

    # Horizontal flags
    Left    = 0x0001_u32
    Right   = 0x0002_u32
    HCenter = 0x0004_u32

    # Vertical flags
    Top     = 0x0020_u32
    Bottom  = 0x0040_u32
    VCenter = 0x0080_u32

    TopLeft     = Top | Left
    BottomLeft  = Bottom | Left
    TopRight    = Top | Right
    BottomRight = Bottom | Right
    Center      = VCenter | HCenter
    Leading     = Left
    Trailing    = Right

    HMask   = Left | Right | HCenter
    VMask   = Top | Bottom | VCenter
  end
end
