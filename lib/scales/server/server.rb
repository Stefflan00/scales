module Scales
  module Server
    
    class Server < Goliath::API
      use Goliath::Rack::Params
      use Goliath::Rack::DefaultMimeType
      use ContentType, 'html'

      def response(env)
        Dispatch.request(env)
      end

    end
    
  end
end