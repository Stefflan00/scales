module Scales
  module PubSub
    module Sync
      class << self
        
        def publish(channel, message)
          Storage::Sync.publish(channel, message)
        end
        
        def subscribe(channel)
          Storage::Sync.subscribe(channel)
        end
        
      end
    end
  end
end