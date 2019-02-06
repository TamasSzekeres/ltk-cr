module Ltk
  @[Flags]
  enum TextOptions : UInt32
    Multiline
    Justify
    IncludeTrailingSpaces

    Singleline = None
  end
end