module Ltk
  enum Alignment : UInt32
    None   = 0

    # Horizontal flags
    Left    = 0x0001_u32
    Right   = 0x0002_u32
    HCenter = 0x0004_u32
    Justify = 0x0008_u32

    # Vertical flags
    Top     = 0x0020_u32
    Bottom  = 0x0040_u32
    VCenter = 0x0080_u32

    Center  = VCenter | HCenter

    Absolute = 0x0010_u32
    Leading  = Left
    Trailing = Right

    HMask   = Left | Right | HCenter | Justify | Absolute
    VMask   = Top | Bottom | VCenter
  end
end
