require "x11"

require "./widget"

module Ltk
  include X11

  class MainWindow < Widget
    def initialize
      super
    end

    def title
      @display.fetch_name @window
    end

    def title=(t : String)
      @display.store_name @window, t
    end
  end
end
