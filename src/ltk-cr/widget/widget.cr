require "./x11-cr/x11/X"
require "./x11-cr/x11/Xlib"

require "../base/rect"
require "../event/*"

module Ltk
  include X11

  class Widget < EventListener
    getter parent : Widget?
    getter geometry : Rect
    getter display : X::PDisplay
    getter screen : Int32
    getter children : Array(Widget)

    def initialize(@parent = nil)
      @geometry = Rect.new 0, 0, 100, 100
      @display = uninitialized X::PDisplay
      @screen = 0
      @children = Array(Widget).new
      create_window
    end

    def finalize
      destroy_window
    end

    protected def create_window
      pwin = uninitialized X11::Window
      if @parent.is_a? Widget
        parent = @parent.as Widget
        @display = parent.display
        @screen = X.default_screen @display
        pwin = parent.window
      else
        #@display = X.open_display nil
        @display = Application.display
        @screen = X.default_screen @display
        pwin = X.root_window @display, @screen
      end

      @window = X.create_simple_window(
        @display, pwin,
        @geometry.x, @geometry.y,
        @geometry.width, @geometry.height, 0,
        X.black_pixel(@display, @screen),
        0x4e4e4e
        #X.white_pixel()@display, @screen)
      )
      X.select_input(
        @display, @window,
        ButtonPressMask | ButtonReleaseMask | ButtonMotionMask |
        ExposureMask |
        EnterWindowMask | LeaveWindowMask |
        KeyPressMask | KeyReleaseMask)

      X.map_window @display, @window
      wm_del_win = Application.wm_delete_window
      X.set_wm_protocols @display, @window, pointerof(wm_del_win), 1
      Application.wm_delete_window = wm_del_win

      Application.add_event_listener self
      unless @parent.is_a? Nil
        (parent.as Widget).add_child self
      else
        Application.add_widget self
      end
    end

    protected def destroy_window
      #@children.each do |child|
      #  child.finalize
      #end
      Application.remove_event_listener self
      X.destroy_window @display, @window
      if (@display != Application.display) ||
        (!(@parent.is_a? Nil) && (@display != (@parent.as Widget).display))
        X.close_display @display
      end
    end

    def event(event : X::Event) : Bool
      return false if event.any.window != @window

      case event.type
      when ButtonPress
        button = case event.button.button
        when 1
          EventButton::Left
        when 2
          EventButton::Middle
        when 3
          EventButton::Right
        else
          EventButton::None
        end
        mouse_down_event(MouseEvent.new(button,
          Point.new(event.button.x, event.button.y),
          Point.new(event.button.x_root, event.button.y_root)))
      when ButtonRelease
        button = case event.button.button
        when 1
          EventButton::Left
        when 2
          EventButton::Middle
        when 3
          EventButton::Right
        else
          EventButton::None
        end
        mouse_up_event(MouseEvent.new(button,
          Point.new(event.button.x, event.button.y),
          Point.new(event.button.x_root, event.button.y_root)))
      when MotionNotify
        #puts "Widget MotionNotify"
      when EnterNotify
        #puts "widget::enter win="
        enter_event
      when LeaveNotify
        #puts "widget::leave win="
        leave_event
      when KeyPress
        #puts "KeyPress Event"
      when KeyRelease
        #puts "KeyRelease Event"
      when Expose
        paint_event
      else
      end

      true
    end

    def repaint
      paint_event
    end

    protected def click_event
    end

    protected def enter_event
    end

    protected def leave_event
    end

    protected def mouse_down_event(event : MouseEvent)
    end

    protected def mouse_up_event(event : MouseEvent)
    end

    protected def paint_event
    end

    def x
      @geometry.x
    end

    def y
      @geometry.y
    end

    def width
      @geometry.width
    end

    def height
      @geometry.height
    end

    def geometry=(rect)
      changes = uninitialized X::WindowChanges
      changes.x = rect.x
      changes.y = rect.y
      changes.width = rect.width
      changes.height = rect.height
      X.configure_window(@display, @window, X11::CWX | X11::CWY | X11::CWWidth | X11::CWHeight, pointerof(changes))
      @geometry = rect
    end

    def set_geometry(x, y, width, height)
      self.geometry = Rect.new x, y, width, height
    end

    def add_child(w)
      @children << w
    end
  end
end
