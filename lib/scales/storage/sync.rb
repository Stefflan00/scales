module Scales
  module Storage
    module Sync
      include Helper::BeforeFilter
      
      before_filter :connect!
      
      @@redis = nil
      
      class << self
        
        def connect!
          return if @@redis && @@redis.client.connected?
          
          @@redis = Redis.new(
            :host => Scales.config.redis_host,
            :port => Scales.config.redis_port
          )
        end
        
        def set(key, value)
          @@redis.set(key, value)
        end
        
        def get(key)
          @@redis.get(key)
        end
        
      end
    end
  end
end