require "../event/event_listener"

require "./alignment"

module Ltk
  abstract class LayoutItem < EventListener
    property alignment : Alignment = Alignment::None

  end
end
