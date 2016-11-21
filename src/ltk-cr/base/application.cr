require "./x11-cr/x11/X"
require "./x11-cr/x11/Xlib"

require "../event/event_listener"

module Ltk
  include X11

  class Application
    WM_DELETE_WINDOW_STR = "WM_DELETE_WINDOW"

    @@display = uninitialized X::PDisplay
    @@wm_delete_window : X11::Atom = 0_u64
    @@event_listeners = Hash(X11::Window, EventListener).new
    @@widgets = Array(Widget).new

    init

    # init
    private def self.init
      @@display = X.open_display nil
      @@wm_delete_window = X.intern_atom(@@display, WM_DELETE_WINDOW_STR, 0)
    end

    private def self.finalize
      X.close_display @@display
    end

    def self.run(args : Array(String))
      #puts "running..."
      return 1 if @@display.is_a? Nil

      event = uninitialized X::Event
      while true
        if X.pending @@display
          X.next_event @@display, pointerof(event)

          #puts "app event=#{event.type} window=#{event.any.window}"

          case event.type
          when ClientMessage
            break if event.client.data.ul[0] == @@wm_delete_window
          else
            el = @@event_listeners.fetch event.any.window, nil
            if el.is_a? EventListener
              (el.as EventListener).event(event)
            end
          end
        end
      end

      finalize
      0
    end

    def self.add_event_listener(el : EventListener)
      @@event_listeners[el.window] = el
    end

    def self.remove_event_listener(el : EventListener)
      @@event_listeners.delete el.window
    end

    def self.add_widget(widget : Widget)
      @@widgets << widget
    end

    def self.display
      @@display
    end

    def self.wm_delete_window
      @@wm_delete_window
    end

    def self.wm_delete_window=(value)
      @@wm_delete_window = value
    end
  end
end
