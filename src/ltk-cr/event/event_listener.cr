require "./x11-cr/x11/X"
require "./x11-cr/x11/Xlib"

module Ltk
  abstract class EventListener
    abstract def event(event : X11::Event) : Bool

    getter window : X11::Window = 0_u64
  end
end
