require "x11"

require "../base/font"
require "../base/margins"
require "../base/rect"
require "../base/size_policies"
require "../enums/key_code"
require "../event/*"
require "../layout/layout"

module Ltk
  include X11

  alias ClickEvent = Proc(Void | Nil)

  class Widget < EventListener
    getter parent : Widget?
    getter layout : Layout? = nil
    getter geometry : Rect
    getter preferred_size : Size
    getter minimum_size : Size
    getter maximum_size : Size
    getter size_policies : SizePolicies
    getter margins : Margins = Margins::ZERO
    getter display : Display
    getter screen : Screen
    getter window : X11::C::Window
    property cursor : X11::C::Cursor = 2
    getter font : Font = Font.new
    getter children : Array(Widget)

    property on_click : ClickEvent?

    def initialize(@parent = nil)
      @style = nil.as(Style?)
      @palette = nil.as(Palette?)
      @geometry = Rect.new 0, 0, 100, 100
      @preferred_size = Size::ZERO
      @minimum_size = Size::ZERO
      @maximum_size = Size::MAX
      @size_policies = SizePolicies.new

      @children = Array(Widget).new
      if @parent.is_a? Widget
        @display = @parent.as(Widget).display
      else
        @display = Application.display
      end
      @screen = @display.default_screen
      create_window

      @font = style.default_font
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
        ExposureMask | StructureNotifyMask |
        FocusChangeMask |
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
      when FocusChangeEvent
        focus_change_event = event.as(FocusChangeEvent)
        case focus_change_event
          when .in?
            self.focus_received_event
          when .out?
            self.focus_lost_event
        end
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
          mouse_down_event(MouseEvent.new(button,
            Point.new(button_event.x, button_event.y),
            Point.new(button_event.x_root, button_event.y_root)))
        else
          mouse_up_event(MouseEvent.new(button,
            Point.new(button_event.x, button_event.y),
            Point.new(button_event.x_root, button_event.y_root)))
        end
      when MotionEvent
        begin
        end
      when CrossingEvent
        if event.as(CrossingEvent).enter?
          enter_event
        else
          leave_event
        end
      when X11::KeyEvent
        case key_event = event.as(X11::KeyEvent)
        when .press?
          key_press_event(Ltk::KeyEvent.new(key_event))
        when .release?
          key_release_event(Ltk::KeyEvent.new(key_event))
        end
      when ExposeEvent
        paint_event
      when ConfigureEvent
        configure_event(event.x, event.y, event.width, event.height)
      else
      end

      true
    end

    def focused? : Bool
      Application.focus_widget == self
    end

    def focus!
      if Application.running?
        Application.focus_widget = self
        @display.set_input_focus(@window, X11::C::RevertToParent, X11::C::CurrentTime)
      end
      self
    end

    def clear_focus
      Application.focus_widget = nil if focused?
      self
    end

    def repaint
      self.paint_event
    end

    protected def click_event
      if on_click = @on_click
        on_click.call
      end
    end

    protected def focus_received_event
      repaint
    end

    protected def focus_lost_event
      repaint
    end

    protected def enter_event
    end

    protected def leave_event
    end

    protected def key_press_event(event : KeyEvent)
    end

    protected def key_release_event(event : KeyEvent)
    end

    protected def mouse_down_event(event : MouseEvent)
      focus!
    end

    protected def mouse_up_event(event : MouseEvent)
    end

    protected def paint_event
    end

    protected def configure_event(new_x : Int32, new_y : Int32, new_width : Int32, new_height : Int32)
      @geometry = Rect.new new_x, new_y, new_width, new_height
      if @layout.is_a? Layout
        @layout.as(Layout).geometry = content_rect
        repaint
      end
    end

    def x : Int32
      @geometry.x
    end

    def y : Int32
      @geometry.y
    end

    def width : Int32
      @geometry.width
    end

    def height : Int32
      @geometry.height
    end

    def geometry=(rect : Rect)
      changes = WindowChanges.new
      changes.x = rect.x
      changes.y = rect.y
      changes.width = Math.max(rect.width, 1)
      changes.height = Math.max(rect.height, 1)
      @display.configure_window(@window, X11::C::CWX | X11::C::CWY | X11::C::CWWidth | X11::C::CWHeight, changes)
      @geometry = rect
    end

    def set_geometry(x : Int32, y : Int32, width : Int32, height : Int32)
      self.geometry = Rect.new x, y, width, height
      self
    end

    def margins=(margins : Margins)
      if @margins != margins
        @margins = margins
        if @layout.is_a?(Layout)
          @layout.as(Layout).geometry = content_rect
        end
      end
    end

    def content_rect : Rect
      Rect.new(@margins.left, @margins.top,
               @geometry.width - @margins.left - @margins.right,
               @geometry.height - @margins.top - @margins.bottom)
    end

    @[AlwaysInline]
    def preferred_width : Int32
      @preferred_size.width
    end

    @[AlwaysInline]
    def preferred_height : Int32
      @preferred_size.height
    end

    def preferred_size=(s : Size)
      @preferred_size = s
      # invalidate_geometry
    end

    @[AlwaysInline]
    def minimum_width : Int32
      @minimum_size.width
    end

    @[AlwaysInline]
    def minimum_height : Int32
      @minimum_size.height
    end

    def minimum_size=(s : Size)
      @minimum_size = s
      # invalidate_geometry
    end

    @[AlwaysInline]
    def maximum_width : Int32
      @maximum_size.width
    end

    @[AlwaysInline]
    def maximum_height : Int32
      @maximum_size.height
    end

    def maximum_size=(s : Size)
      @maximum_size = s
      # invalidate_geometry
    end

    @[AlwaysInline]
    def horitontal_size_policy : SizePolicy
      @size_policies.horizontal
    end

    @[AlwaysInline]
    def vertical_size_policy : SizePolicy
      @size_policies.vertical
    end

    def size_policies=(@size_policies : SizePolicies)
      # invalidate_geometry
    end

    def set_size_policies(horizontal : SizePolicy = SizePolicy::Expanding, vertical : SizePolicy = SizePolicy::Expanding)
      @size_policies = SizePolicies.new(horizontal, vertical)
    end

    def layout=(layout : Layout?)
      @layout = layout
    end

    def font=(@font : Font)
      repaint
    end

    def style : Style
      @style.same?(nil) ? Application.style : @style.not_nil!
    end

    def style=(style : Style)
      @style = style
      repaint
    end

    def palette : Palette
      @palette.same?(nil) ? Application.palette : @palette.not_nil!
    end

    def palette=(palette : Palette)
      @palette = palette
      repaint
    end

    def add_child(w)
      @children << w
      self
    end
  end
end
