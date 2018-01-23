require "x11"

require "../event/event_listener"

module Ltk
  include X11

  abstract class Application
    WM_DELETE_WINDOW_STR = "WM_DELETE_WINDOW"

    @@display = Display.new
    @@wm_delete_window = 0_u64
    @@wm_delete_window = @@display.intern_atom(WM_DELETE_WINDOW_STR, false)
    @@event_listeners = Hash(X11::C::Window, EventListener).new
    @@widgets = Array(Widget).new

    @running = false

    private def self.finalize
      @@display.close
    end

    def self.run(args : Array(String))
      return 1 if @@display.is_a? Nil

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
      GC.collect
      0
    end

    def self.close
      @@running = false
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

    def self.is_running?
      @@running
    end
  end
end
