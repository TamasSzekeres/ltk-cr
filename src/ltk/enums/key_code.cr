module Ltk
  enum KeyCode : UInt32
    A = 38_u32
    Space = 65_u32

    def self.from(value : UInt32) : KeyCode
      KeyCode.new(value)
    end

    def to_char : Char
      case self
        when A then 'a'
        else
          ' '
      end
    end
  end
end
