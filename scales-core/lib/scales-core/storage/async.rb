module Scales
  module Storage
    module Async      
      @@redis = nil
        
      class << self
        
        def connect!
          return if @@redis and @@redis.connected?
          @@redis = new_connection!
        end
        
        def connection
          @@redis
        end
        
        def set(key, value)
          with_connection{ @@redis.set(key, value) }
        end
        
        def get(key)
          with_connection{ @@redis.get(key) }
        end
        
        def del(key)
          with_connection{ @@redis.del(key) }
        end
        
        def add(queue, job)
          with_connection{ @@redis.lpush(queue, job) }
        end
        
        def pop(queue)
          with_new_connection{ |redis| redis.brpop(queue, 0) }.last
        end
        
        def publish(channel, message)
          add(channel, message)
        end
        
        def subscribe(channel)
          pop(channel)
        end
        
        def flushall!
          with_connection{ @@redis.flushall }
        end
        
        private
        
        def new_connection!
          EM::Hiredis.connect "redis://:#{Scales.config.password}@#{Scales.config.host}:#{Scales.config.port}/#{Scales.config.database}"
        end
        
        def with_connection
          connect!
          yield
        end
        
        # Creates a new connection for blocking calls and closes it after the block
        def with_new_connection
          redis = new_connection!
          out = yield(redis)
          redis.quit
          redis = nil
          out
        end
        
      end
      
    end
  end
end