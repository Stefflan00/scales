module Scales
  module PubSub
    module Async
      class << self
        
        def publish(channel, message)
          Storage::Async.publish(channel, message)
        end
        
        def subscribe(channel)
          out = Storage::Async.subscribe(channel)
          Storage::Async.del(channel)
          out
        end
        
      end
    end
  end
end