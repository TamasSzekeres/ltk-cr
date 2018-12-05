module Ltk
  enum SizePolicy : UInt32
    Fixed  = 0_u32
    Shrink = 1_u32
    Grow   = 2_u32

    Minimum = Grow
    Maximum = Shrink
    Expanding = Grow | Shrink
  end
end
