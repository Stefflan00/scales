module Scales
  class Server < Goliath::API
    
    def response(env)
      Dispatch.request(env)
    end
    
  end
end