module Scales
  module Storage
    module Async
      include Helper::BeforeFilter
      
      before_filter :connect!
      
      @@redis = nil
        
      class << self
        
        def connect!
          return if @@redis && @@redis.connected?
          @@redis = EM::Hiredis.connect "redis://#{Scales.config.redis_host}:#{Scales.config.redis_port}"
        end
        
        def set(key, value)
          @@redis.set(key, value) do
            yield
          end
        end
        
        def get(key)
          @@redis.get(key) do |value|
            yield(value)
          end
        end
        
      end
      
    end
  end
end