require "ltk"

module LineEdit
  include Ltk

  class Example
    def main
      # Creating The Main Window.
      main_win = MainWindow.new
      main_win.object_name = "main_win"
      main_win.title = "Ltk-Win"
      main_win.geometry = Rect.new 10, 10, 190, 113

      # Creating a PushButton on the Main Window.
      push_button = PushButton.new "PushButton", main_win
      push_button.object_name = "push_button"
      push_button.geometry = Rect.new 20, 20, 150, 23

      # Create a LineEdit on the Main Window
      line_edit = LineEdit.new main_win
      line_edit.object_name = "line_edit"
      line_edit.geometry = Rect.new 20, 63, 150, 23
      line_edit.text = "line"
      line_edit.focus!
      #p line_edit.focused?

      # Runs the application.
      Application.run ARGV
    end

    Example.new.main
  end
end
