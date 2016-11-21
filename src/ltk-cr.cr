require "./ltk-cr/base/*"
require "./ltk-cr/layout/*"
require "./ltk-cr/widget/*"
require "./ltk-cr/*"

module Ltk
  puts "Start Ltk Sample - Cr"

  args = [] of String
  #Application.init args

  main_win = MainWindow.new
  main_win.title = "LTK-Win"
  main_win.geometry = Rect.new 10, 10, 800, 600

  puts "mainWin.title=#{main_win.title}"

  btn = PushButton.new "Kilépés", main_win
  btn.geometry = Rect.new 20, 20, 150, 23

  Application.run args
end
