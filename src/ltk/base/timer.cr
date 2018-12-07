module Ltk
  alias TimerProc = Proc(Void?)

  class Timer
    property interval : ::Time::Span
    getter? looping = false

    def initialize(@interval = 1.second)
      @timeout = nil
    end

    def initialize(@interval = 1.second, &block : Timer -> Void)
      @timeout = block
    end

    def on_timeout(&block : Timer -> Void)
      @timeout = block
    end

    private def timeout
      if callback = @timeout
        callback.call(self)
      end
    end

    def start
      @start_at = ::Time.now
      @looping = true
      run
    end

    def stop
      @looping = false
    end

    private def run
      spawn do
        interval = @interval
        while @looping
          sleep interval
          if @looping
            timeout
          end
        end
      end
    end
  end
end
