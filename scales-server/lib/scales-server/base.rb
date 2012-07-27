module Scales
  module Server
    class << self
      
      def run!
        ARGV << "--stdout" << "--environment" << "#{Scales.env}"
        
        server = Server.new

        runner = Goliath::Runner.new(ARGV, server)
        runner.app = Goliath::Rack::Builder.build(Server, server)

        runner.load_plugins(Server.plugins)
        runner.run
      end
      
    end
  end
end