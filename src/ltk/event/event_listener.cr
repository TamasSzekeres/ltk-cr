require "x11"

require "../base/base_object"

module Ltk
  abstract class EventListener < BaseObject
    abstract def event(event : X11::Event) : Bool

    getter window : X11::C::Window = 0_u64
  end
end
