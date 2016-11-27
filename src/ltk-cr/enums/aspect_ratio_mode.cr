module Ltk
  enum AspectRatioMode
    Ignore # The size is scaled freely. The aspect ratio is not preserved.
    Keep   # The size is scaled to a rectangle as large as possible inside a given rectangle, preserving the aspect ratio.
    KeepByExpanding # The size is scaled to a rectangle as small as possible outside a given rectangle, preserving the aspect ratio.
  end
end
