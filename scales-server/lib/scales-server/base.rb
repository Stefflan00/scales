module Scales
  module Server
    class << self
      
      def run!
        server = Server.new

        runner = Goliath::Runner.new(ARGV, server)
        runner.app = Goliath::Rack::Builder.build(Server, server)

        runner.load_plugins(Server.plugins)
        runner.run
      end
      
    end
  end
end