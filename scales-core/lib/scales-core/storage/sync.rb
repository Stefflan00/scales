module Scales
  module Storage
    module Sync
      @@redis = nil
      
      class << self
        
        def connect!
          return if @@redis && @@redis.client.connected?
          @@redis = new_connection!
        end
        
        def connection
          @@redis
        end
        
        def set(key, value)
          with_connection(key){ @@redis.set(key, value) }
        end
        
        def get(key, partials = false)
          with_connection(key){ partials ? Helper::PartialResolver.resolve(@@redis, key) : @@redis.get(key) }
        end
        
        def del(key)
          with_connection(key){ @@redis.del(key) }
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
          Redis.new(
            :host     => Scales.config.host, 
            :port     => Scales.config.port, 
            :password => Scales.config.password, 
            :database => Scales.config.database
          )
        end
        
        def with_connection(key = nil)
          ReservedKeys.validate!(key) if key
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