module Scales
  module Monitor
    
    APP_DIR = File.expand_path("../app", __FILE__)
    
    class Monitor
      
      def initialize
        start!
      end
      
      def start!
        @pid = spawn "cd #{APP_DIR} && thin start -R monitor.ru"
        sleep 4
      end
      
      def stop!
        Process.kill('INT', -Process.getpgid(@pid))
      end
      
    end
    
  end
end