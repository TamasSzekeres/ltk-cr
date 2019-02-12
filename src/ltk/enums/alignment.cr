module Ltk
  @[Flags]
  enum Alignment : UInt32
    # Horizontal flags
    Left    = 0x0001_u32
    Right   = 0x0002_u32
    HCenter = 0x0004_u32

    # Vertical flags
    Top     = 0x0020_u32
    Bottom  = 0x0040_u32
    VCenter = 0x0080_u32

    # Combined flags
    TopLeft      = Top | Left
    TopCenter    = Top | HCenter
    TopRight     = Top | Right
    CenterLeft   = Left | VCenter
    CenterRight  = Right | VCenter
    BottomLeft   = Bottom | Left
    BottomCenter = Bottom | HCenter
    BottomRight  = Bottom | Right
    Center       = VCenter | HCenter

    # Aliases
    Leading      = Left
    Trailing     = Right
    LeftCenter   = CenterLeft
    RightCenter  = CenterRight

    # Masks
    HMask   = Left | Right | HCenter
    VMask   = Top | Bottom | VCenter
  end
end
