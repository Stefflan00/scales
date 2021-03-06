module Scales
  module Monitor
    
    class WebSocket < Goliath::WebSocket
      use Server::ContentType, 'html'
      
      def on_open(env)
        send_initial_statuses(env)
        setup_subscription!
        add_to_subscribers(env)
      end

      def on_error(env, error)
        env.logger.error error
      end

      def on_message(env, msg)
      end

      def on_close(env)
        remove_from_subscribers(env) if env['REQUEST_PATH'] == "/socket"
      end
      
      def response(env)
        path = env['REQUEST_PATH']
        
        if path == '/socket'
          super(env)
        else
          [200, {}, Monitor.serve(path)]
        end
      end
      
      private
      
      def setup_subscription!
        return if @subscribed
        @subscribers = []
        
        events = Storage::Async.new_connection!
        events.subscribe("scales_monitor_events")
        events.on(:message) do |channel, message|
          @subscribers.each { |subscriber| subscriber.stream_send(message) }
        end
        
        @subscribed = true
      end
      
      def add_to_subscribers(env)
        @subscribers << env
      end
      
      def remove_from_subscribers(env)
        @subscribers.delete(env)
      end
      
      def send_initial_statuses(env)
        server_statuses.each{ |server| env.stream_send(server)    }
        cache_statuses.each{  |cache|  env.stream_send(cache)     }
        worker_statuses.each{ |worker| env.stream_send(worker)    }
        
        request_queue.each{  |request| env.stream_send(request)   }
        
        push_resources.each{ |resource| env.stream_send(resource) }
        push_partials.each{  |partial|  env.stream_send(partial)  }
      end

      def server_statuses
        servers = Storage::Async.connection.keys("scales_server_*")
        return [] if servers.empty?
        
        Storage::Async.connection.mget(*servers)
      end
      
      def cache_statuses
        info = Storage::Async.connection.info
        data  = {
          :id         => redis_value("run_id", info)[0..16],
          :key        => "",
          :type       => "cache_started",
          :spawned_at => Time.now.to_i - redis_value("uptime_in_seconds", info).to_i,
          :env        => Scales.env,
          :ip         => Scales.config.host,
          :port       => Scales.config.port
        }
        [JSON.generate(data)]
      end
      
      def worker_statuses
        workers = Storage::Async.connection.keys("scales_worker_*")
        return [] if workers.empty?
        
        Storage::Async.connection.mget(*workers)
      end
      
      def request_queue
        requests = Storage::Async.connection.llen(Scales::Storage::REQUEST_QUEUE)
        return [] if requests == 0
        
        data = []
        Storage::Async.connection.lrange(Scales::Storage::REQUEST_QUEUE, 0, requests).each do |request|
          job = JSON.parse(request)
          data << {
            :id         => job['scales.id'],
            :server_id  => nil,
            :type       => "server_put_request_in_queue",
            :path       => job['PATH_INFO'],
            :method     => job['REQUEST_METHOD']
          }.to_json
        end
        data
      end
      
      def push_resources
        resources = Storage::Async.connection.keys("scales_resource_/*")
        return [] if resources.empty?
        
        data = []
        resources.each do |resource|
          data << {
            :path       => resource.gsub("scales_resource_", ""),
            :format     => format(resource),
            :type       => "push_resource"
          }.to_json
        end
        data
      end
      
      def push_partials
        partials = Storage::Async.connection.keys("scales_partial_*")
        return [] if partials.empty?
        
        data = []
        partials.each do |partial|
          data << {
            :path       => partial.gsub("scales_partial_", ""),
            :format     => format(partial),
            :type       => "push_partial"
          }.to_json
        end
        data
      end
      
      private
      
      def redis_value(value, info)
        info.scan(/^#{value}:.*/).first.split(":").last
      end
      
      def format(path)
        format = "HTML"
        Scales::Helper::ContentTypes::TYPES.each { |aformat, type| format = aformat.to_s.upcase and break if path =~ /\.#{aformat}(\?|$)/ }
        format
      end
      
    end
    
  end
end