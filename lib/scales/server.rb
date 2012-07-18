module Scales
  class Server < Goliath::API
    use Goliath::Rack::Params
    use Goliath::Rack::DefaultMimeType
    use Scales::ContentType, 'html'
    
    def response(env)
      Dispatch.request(env)
    end
    
  end
end