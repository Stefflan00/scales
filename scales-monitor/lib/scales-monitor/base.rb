module Scales
  module Monitor
    class << self
      
      def run!
        ARGV << "--stdout" << "--environment" << "#{Scales.env}"
        
        monitor     = WebSocket.new
        runner      = Goliath::Runner.new(ARGV, monitor)
        runner.app  = Goliath::Rack::Builder.build(WebSocket, monitor)
        runner.load_plugins(WebSocket.plugins)     
        runner.run
      end
      
    end
  end
end