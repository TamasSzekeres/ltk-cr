module Ltk
  struct Size
    property width : Int32
    property height : Int32

    def initialize(@width, @height)
    end

    def transposed
      # TODO implement this
      Size.new 0, 0
    end
  end
end
