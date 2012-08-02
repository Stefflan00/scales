module Scales
  module Server
    
    require 'logger'
    @@logger = ::Logger.new('log/scales_server.log')
    
    class << self
      def logger
        @@logger
      end
    end
    
    class Server < Goliath::API
      use Goliath::Rack::Params
      use Goliath::Rack::DefaultMimeType
      use ContentType, 'html'

      def response(env)
        response = Dispatch.request(env)
        
        if response.first == 404
          if response.last.is_a?(String)
            Scales::Server.logger.error(response.last)
          else
            message = ""
            response.last.each{ |chunk| message << chunk }
            Scales::Server.logger.error(message)
          end
        end
        
        response
      end

    end
    
  end
end