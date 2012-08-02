module Scales
  module Storage
    module Sync
      @@redis = nil
      @@pids = [Process.pid]
      
      class << self
        
        def connect!
          return if @@redis && @@redis.client.connected?
          @@redis = new_connection!
        end
        
        def force_reconnect!
          @@redis = new_connection!
        end
        
        def connection
          with_connection{ @@redis }
        end
        
        def set_content(path, value)
          set(Storage.prefix(path), value)
        end
        
        def get_content(path, partials = false)
          get(Storage.prefix(path), partials)
        end
        
        def del_content(path)
          del(Storage.prefix(path))
        end
        
        def set(key, value)
          with_connection{ @@redis.set(key, value) }
        end
        
        def get(key, partials = false)
          with_connection{ partials ? Helper::PartialResolver.resolve(@@redis, key) : @@redis.get(key) }
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
        
        def new_connection!
          Redis.new(
            :host     => Scales.config.host, 
            :port     => Scales.config.port, 
            :password => Scales.config.password, 
            :db       => Scales.config.database
          )
        end
        
        private
        
        def with_connection
          
          # Reconnects forks
          unless @@pids.include?(Process.pid)
            force_reconnect!
            @@pids << Process.pid
          end
          
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