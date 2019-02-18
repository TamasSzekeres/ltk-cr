module Ltk
  enum CheckState
    Unchecked
    PartiallyChecked
    Checked

    def next(tristate : Bool = false) : self
      if tristate
        case self
        when Unchecked then PartiallyChecked
        when PartiallyChecked then Checked
        else Unchecked
        end
      else
        self == Unchecked ? Checked : Unchecked
      end
    end
  end
end
