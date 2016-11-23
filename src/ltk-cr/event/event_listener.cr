require "./x11-cr/x11/X"
require "./x11-cr/x11/Xlib"

require "../base/base_object"

module Ltk
  abstract class EventListener < BaseObject
    abstract def event(event : X11::Event) : Bool

    getter window : X11::Window = 0_u64
  end
end
