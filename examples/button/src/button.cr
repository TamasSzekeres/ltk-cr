require "ltk"

module Button
  include Ltk

  class Example
    # Haindling of clicking on the close_button.
    def close_button_click
      puts "close_button clicked!"
      Application.close
    end

    def main
      # Creating The Main Window.
      main_win = MainWindow.new
      main_win.title = "Ltk-Win"
      main_win.geometry = Rect.new 10, 10, 190, 63

      # Creating a PushButton on the Main Window.
      close_button = PushButton.new "Close", main_win
      close_button.object_name = "close_button"
      close_button.geometry = Rect.new 20, 20, 150, 23
      close_button.on_click = ->close_button_click

      # Runs the application.
      Application.run ARGV
    end

    Example.new.main
  end
end
