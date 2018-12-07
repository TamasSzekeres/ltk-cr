module Ltk
  alias TimerProc = Proc(Void?)

  class Timer
    property interval : ::Time::Span
    property stop_at : Time?
    property timer_event : TimerProc? = nil
    property timeout_event : TimerProc? = nil
    getter start_at : Time? = nil
    getter? looping = false

    def initialize(@interval = 1, @stop_at = nil)
    end

    def initialize(@interval = 1, @stop_at = nil, &@timer_event)
    end

    def start
      @start_at = Time.now
      @looping = true
      run
    end

    def stop
      @looping = false
      if @timeout_event.is_a? TimerProc
        @timeout_event.as(TimerProc).call
      end
    end

    private def run
      spawn do
        interval = @interval
        while @looping
          sleep interval
          if @timer_event.is_a? TimerProc
            @timer_event.as(TimerProc).call
          end

          if stop_at = @stop_at
            stop if stop_at <= Time.now
          end
        end
      end
    end

    def remaining_time : Time::Span
      if @looping && @start_at.is_a?(Time)
        Time.now - @start_at.as(Time)
      else
        Time::Span.new nanoseconds: 0
      end
    end
  end
end
