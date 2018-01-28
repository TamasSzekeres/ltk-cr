module Ltk
  abstract class Layout < BaseObject
    getter parent : (Widget | Layout)? = nil
    getter geometry : Rect = Rect.new

    def parent_widget : Widget?
      case @parent
        when Widget then @parent.as(Widget)
        when Layout then @parent.as(Layout).parent_widget
        else
          nil
      end
    end

    protected def arrange_items
    end

    abstract def remove_items

    abstract def preferred_size : Size

    def minimum_size : Size
      Size.ZERO
    end

    def maximum_size : Size
      Size.MAX
    end

    def parent=(parent : (Widget | Layout)?)
      unless @parent.nil?
        if parent.nil?
          @parent.layout = nil
          remove_items
        end
      end
      @parent = parent
      unless @parent.nil?
        @geometry = @parent.geometry
        arrange_items
      end
    end

    def geometry=(r : Rect)
      @geometry = r
      arrange_items
    end
  end
end
