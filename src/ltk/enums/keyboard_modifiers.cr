module Ltk
  @[Flags]
  enum KeyboardModifiers : UInt32
    Shift
    Lock
    Control
    Mod1
    Mod2
    Mod3
    Mod4
    Mod5

    CapsLock = Lock
    NumLock = Mod2
    Alt = Mod1
    AltGr = Mod5
  end
end
