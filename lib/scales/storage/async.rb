module Scales
  module Storage
    module Async
      include Helper::BeforeFilter
      
      before_filter :connect!
      
      @@redis = nil
        
      class << self
        
        def connect!
          return if @@redis and @@redis.connected?
          @@redis = EM::Hiredis.connect "redis://#{Scales.config.redis_host}:#{Scales.config.redis_port}"
        end
        
        def connection
          @@redis
        end
        
        def set(key, value)
          @@redis.set(key, value)
        end
        
        def get(key)
          @@redis.get(key)
        end
        
        def del(key)
          @@redis.del(key)
        end
        
        def add(queue, job)
          @@redis.lpush(queue, job)
        end
        
        def pop(queue)
          @@redis.brpop(queue, 0).last
        end
        
      end
      
    end
  end
end