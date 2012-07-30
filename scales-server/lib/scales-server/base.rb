module Scales
  module Server
    class << self
      
      def run!
        ARGV << "--stdout" << "--environment" << "#{Scales.env}"
        
        server      = Server.new
        runner      = Goliath::Runner.new(ARGV, server)
        runner.app  = Goliath::Rack::Builder.build(Server, server)
        runner.load_plugins(Server.plugins)
        
        status = Status.new(runner.address, runner.port)
        status.start!
        at_exit{ status.stop! }
        Scales::Server.status = status
        
        runner.run
      end
      
      @@status = nil
      def status
        @@status
      end
      
      def status=(status)
        @@status = status
      end
      
    end
  end
end