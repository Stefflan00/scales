module Scales
  module PubSub
    module Async
      class << self
        
        def publish(channel, message)
          Storage::Async.publish(channel, message)
        end
        
        def subscribe(channel)
          Storage::Async.subscribe(channel)
        end
        
      end
    end
  end
end