module Scales
  module Monitor
    
    class WebSocket < Goliath::WebSocket
      use Server::ContentType, 'html'
      
      def on_open(env)
        send_initial_statuses(env)
      end

      def on_error(env, error)
        env.logger.error error
      end

      def on_message(env, msg)
        env.stream_send(msg)
      end

      def on_close(env)
      end
      
      def response(env)
        env.logger.info "Scales.config.database #{Scales.config.database}"
        path = env['REQUEST_PATH']
        
        if path == '/socket'
          super(env)
        else
          [200, {}, Monitor.serve(path)]
        end
      end
      
      private
      
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