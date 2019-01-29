require "locale"
require "x11"

require "../event/event_listener"

at_exit { GC.collect }

module Ltk
  include X11

  module Application
    extend self

    WM_DELETE_WINDOW_STR = "WM_DELETE_WINDOW"

    @@display = Display.new
    @@wm_delete_window = 0_u64
    @@wm_delete_window = @@display.intern_atom(WM_DELETE_WINDOW_STR, false)
    @@event_listeners = Hash(X11::C::Window, EventListener).new
    @@widgets = Array(Widget).new

    @@focus_widget : Widget? = nil

    @running = false

    class_getter keyboard_modifiers : KeyboardModifiers = KeyboardModifiers::None
    class_property style : Style = Style.new
    class_property palette : Palette = Palette::DARK

    private def finalize
      @@display.close
    end

    def run(args : Array(String))
      return 1 if @@display.is_a? Nil

      LibC.setlocale(LibC::LC_ALL, "")

      @@running = true
      while @@running
        if @@display.events_queued(X11::C::X::QueuedAfterFlush) > 0
          event = @@display.next_event
          case event
          when ClientMessageEvent
            close if event.long_data[0] == @@wm_delete_window
          else
            if event.is_a?(WindowEvent)
              win = event.as(WindowEvent).window
              el = @@event_listeners.fetch event.as(WindowEvent).window, nil
              if el.is_a? EventListener
                (el.as EventListener).event(event)
              end
            end
          end
        else
          Fiber.yield
        end
      end

      finalize
      0
    end

    def close
      @@running = false
    end

    def add_event_listener(el : EventListener)
      @@event_listeners[el.window] = el
    end

    def remove_event_listener(el : EventListener)
      @@event_listeners.delete el.window
    end

    def add_widget(widget : Widget)
      @@widgets << widget
    end

    def display
      @@display
    end

    def wm_delete_window
      @@wm_delete_window
    end

    def wm_delete_window=(value)
      @@wm_delete_window = value
    end

    def running?
      @@running
    end

    def focus_widget : Widget?
      @@focus_widget
    end

    def focus_widget=(widget : Widget?)
      @@focus_widget = widget
    end
  end
end
