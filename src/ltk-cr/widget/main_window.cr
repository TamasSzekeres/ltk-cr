require "./x11-cr/x11/X"
require "./x11-cr/x11/Xlib"

require "./widget"

module Ltk
  include X11

  class MainWindow < Widget
    def initialize
      puts "MainWindow::initialize start"
      super
    end

    def title
      #c_str = uninitialized PChar
      #X.fetch_name(@display, @window, pointerof(c_str))
      "title"
    end

    def title=(t : String)
      #X.store_name(@display, @window, t)
    end
  end
end
