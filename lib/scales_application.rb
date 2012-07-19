require 'drb/drb'

module ScalesApplication
  URI   = "druby://localhost:8787"
  
  autoload :Rails, "scales_application/rails"
  
  class << self
    @@pid = nil
    
    def run!(klass = Rails)
      @@pid = fork do
        $running = true
        Signal.trap("INT") { $running = false }
        
        DRb.start_service(URI, klass.app)
        while $running do sleep(1) end
        DRb.stop_service
      end
      
      wait_until_started
    end
    
    def stop!
      Process.kill("INT", @@pid)
      Process.wait
    end
    
    private
    
    def wait_until_started
      DRb.start_service
      loaded = false
      while !loaded do
        begin
          DRbObject.new_with_uri(URI).inspect
          loaded = true
        rescue
          # try again
        end
        sleep 0.1
      end
      
    end
  end
  
end