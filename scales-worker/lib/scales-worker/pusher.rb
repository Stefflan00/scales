module Scales
  module Worker
    class Pusher
      attr_reader :app
      attr_reader :type
      attr_reader :total
      attr_reader :done
      attr_reader :progress
    
      def initialize(type = Application::Rails)
        @type, @app = type, type.app
        reset_progress!
      end
      
      def reset_progress!
        @total, @done = 0, 0
      end
      
      def progress
        ((@done.to_f / @total.to_f) * 100).to_i rescue 0
      end
      
      def is_running?
        @total != @done
      end
      
      def loop_status!
        Thread.new {
          while is_running? do
            print "       Scaling up #{@done}/#{@total} (#{progress}%)".green
            sleep 0.5
            print "\b"
          end
          puts "\n       Done.".green
        }.join
      end
      
      def process!(path)
        env = Path.with_options_to_env(path)
        
        response  = @app.call(env)
        response.last.close
        Storage::Sync.set(path[:to], Response.to_string(response))
        env
      end
      
      def post_process!(env)
        while path = Thread.current[:post_process_queue].pop
          request = Path.to_env(path, env)
          
          begin
            response  = @app.call(request)
            response.last.close
            content   = Response.to_string(response)
            
            Scales.push(content, :to => path)
          rescue Exception => e
            puts e
          end
        end
      end
      
      # Process a single path in thread
      def process_push!(path, should_wait_for_request_to_finish = false)        
        thread = Thread.new do
          Thread.current[:post_process_queue] = []
          env = process!(path)
          post_process!(env)
          @done += 1
        end
        
        thread.join if should_wait_for_request_to_finish
      end
      
      def push!(paths, should_wait_for_request_to_finish = false)
        raise "No Paths added".red if paths.nil? or paths.empty?
        @total, @done = paths.size, 0
        paths.each { |path| process_push!(path, should_wait_for_request_to_finish) }
      end
    end
  end
end