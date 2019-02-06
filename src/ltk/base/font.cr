require "../enums/font_slant"
require "../enums/font_weight"

module Ltk
  struct Font
    property family : String = ""
    property size : Float64 = 10.0
    property slant : FontSlant = FontSlant::Normal
    property weight : FontWeight = FontWeight::Normal

    def initialize
    end
    
    def initialize(@family : String, @size : Float64, @slant : FontSlant, @weight : FontWeight)
    end
  end
end