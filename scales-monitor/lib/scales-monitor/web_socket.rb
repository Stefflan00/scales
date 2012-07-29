module Scales
  module Monitor
    
    class WebSocket < Goliath::WebSocket
      use Server::ContentType, 'html'
      
      def on_open(env)
        send_initial_statuses(env)
        setup_subscription
        add_to_subscribers(env)
      end

      def on_error(env, error)
        env.logger.error error
      end

      def on_message(env, msg)
        env.stream_send(msg)
      end

      def on_close(env)
        remove_from_subscribers(env)
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
      
      def setup_subscription
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
        server_statuses.each{ |server| env.stream_send(server) }
        worker_statuses.each{ |worker| env.stream_send(worker) }
      end

      def server_statuses
        servers = Storage::Async.connection.keys("scales_server_*")
        return [] if servers.empty?
        
        Storage::Async.connection.mget(*servers)
      end
      
      def worker_statuses
        workers = Storage::Async.connection.keys("scales_worker_*")
        return [] if workers.empty?
        
        Storage::Async.connection.mget(*workers)
      end
      
    end
    
  end
end