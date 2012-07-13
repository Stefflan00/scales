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
        
        def connection
          @@redis
        end
        
        def set(key, value)
          @@redis.set(key, value) do
            yield if block_given?
          end
        end
        
        def get(key)
          @@redis.get(key) do |value|
            yield(value) if block_given?
          end
        end
        
        def add(queue, job)
          @@redis.lpush queue, job do
            yield if block_given?
          end
        end
        
        def pop(queue)
          @@redis.brpop(queue) do |value|
            yield(value.last)
          end
        end
        
      end
      
    end
  end
end