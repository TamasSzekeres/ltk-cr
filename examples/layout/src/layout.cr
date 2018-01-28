require "ltk"

module Layout
  include Ltk

  class Example
    # Handling of clicking on the close_button.
    def close_button_click
      puts "close_button clicked!"
      Application.close
    end

    def main
      # Creating The Main Window.
      main_win = MainWindow.new
      main_win.title = "Ltk-Win"
      main_win.geometry = Rect.new 10, 10, 400, 300
      main_win.margins = Margins.new 20, 20, 20, 20

      # Creating a PushButton on the Main Window.
      one_button = PushButton.new "One", main_win
      one_button.object_name = "one_button"
      one_button.geometry = Rect.new 20, 20, 150, 23
      one_button.on_click = ->close_button_click

      two_button = PushButton.new "Two", main_win
      two_button.object_name = "two_button"
      two_button.geometry = Rect.new 20, 60, 150, 23
      two_button.on_click = ->close_button_click

      layout = HorizontalLayout.new nil
      layout.add_widget one_button
      layout.add_widget two_button

      main_win.layout = layout

      # Runs the application.
      Application.run ARGV
    end
  end

  Example.new.main
end
