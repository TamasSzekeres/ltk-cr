require "x11"

require "../base/rect"
require "../event/*"
require "../layout/layout"
require "../layout/layout_item"

module Ltk
  include X11

  alias ClickEvent = Proc(Void | Nil)

  class Widget < LayoutItem
    getter parent : Widget?
    getter geometry : Rect
    getter display : Display
    getter screen : Screen
    getter children : Array(Widget)

    property on_click : ClickEvent?

    def initialize(@parent = nil)
      @geometry = Rect.new 0, 0, 100, 100
      @children = Array(Widget).new
      if @parent.is_a? Widget
        @display = @parent.as(Widget).display
      else
        @display = Application.display
      end
      @screen = @display.default_screen
      create_window
    end

    def finalize
      destroy_window
    end

    protected def create_window
      if @parent.is_a? Widget
        pwin = @parent.as(Widget).window
      else
        pwin = @display.root_window @screen.screen_number
      end

      @window = @display.create_simple_window(
        pwin,
        @geometry.x, @geometry.y,
        @geometry.width.to_u32, @geometry.height.to_u32, 0_u32,
        @display.black_pixel(@screen.screen_number),
        0x4e4e4e_u64
      )
      @display.select_input(
        @window,
        ButtonPressMask | ButtonReleaseMask | ButtonMotionMask |
        ExposureMask |
        EnterWindowMask | LeaveWindowMask |
        KeyPressMask | KeyReleaseMask)

      @display.map_window @window
      wm_del_win = Application.wm_delete_window
      @display.set_wm_protocols @window, [wm_del_win]
      Application.wm_delete_window = wm_del_win

      Application.add_event_listener self
      unless @parent.is_a? Nil
        parent.as(Widget).add_child self
      else
        Application.add_widget self
      end
    end

    protected def destroy_window
      @children.each do |child|
        child.finalize
      end
      Application.remove_event_listener self
      @display.destroy_window @window
      if (@display != Application.display) ||
        (!(@parent.is_a? Nil) && (@display != @parent.as(Widget).display))
        @display.close
      end
    end

    def event(event : X11::Event) : Bool
      if event.is_a?(WindowEvent) && event.as(WindowEvent).window != @window
        return false
      end

      case event
      when ButtonEvent
        button_event = event.as(ButtonEvent)
        button = case button_event.button
        when 1
          EventButton::Left
        when 2
          EventButton::Middle
        when 3
          EventButton::Right
        else
          EventButton::None
        end
        if button_event.press?
          self.mouse_down_event(MouseEvent.new(button,
            Point.new(button_event.x, button_event.y),
            Point.new(button_event.x_root, button_event.y_root)))
        else
          self.mouse_up_event(MouseEvent.new(button,
            Point.new(button_event.x, button_event.y),
            Point.new(button_event.x_root, button_event.y_root)))
        end
      when MotionEvent
        begin
        end
      when CrossingEvent
        if event.as(CrossingEvent).enter?
          self.enter_event
        else
          self.leave_event
        end
      when KeyEvent
        begin
        end
      when ExposeEvent
        self.paint_event
      else
      end

      true
    end

    def repaint
      self.paint_event
    end

    protected def click_event
      if @on_click.is_a? ClickEvent
        (@on_click.as ClickEvent).call
      end
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
      changes = WindowChanges.new
      changes.x = rect.x
      changes.y = rect.y
      changes.width = rect.width
      changes.height = rect.height
      @display.configure_window(@window, X11::C::CWX | X11::C::CWY | X11::C::CWWidth | X11::C::CWHeight, changes)
      @geometry = rect
    end

    def set_geometry(x, y, width, height)
      self.geometry = Rect.new x, y, width, height
      self
    end

    def add_child(w)
      @children << w
      self
    end
  end
end
