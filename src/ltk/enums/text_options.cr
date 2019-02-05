module Ltk
  @[Flags]
  enum TextOptions : UInt32
    Multiline
    Justify
    IncludeTrailingSpaces

    def single_line? : Bool
      !multiline?
    end
  end
end