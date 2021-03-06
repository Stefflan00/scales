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

      def process!(path)
        env = Path.with_options_to_env(path)
        
        response  = @app.call(env)
        response.last.close if response.last.respond_to?(:close)
        
        push_response(path, Response.to_string(response)) if path[:push]
        
        env
      end
      
      def post_process!(env)
        while path = Thread.current[:post_process_queue].pop
          request = Path.to_env(path, env)
          
          begin
            response  = @app.call(request)
            response.last.close if response.last.respond_to?(:close)
          rescue Exception => e
            puts e
          end
        end
      end
      
      # Process a single path in thread
      def process_push!(path)
        Thread.current[:post_process_queue] = []
        env = process!(path)
        post_process!(env)
        @done += 1
      end
      
      def push!(paths)
        raise "No Paths added".red if paths.nil? or paths.empty?
        
        puts "Environment:    #{Scales.env}".green
        puts "Application:    #{@type.name}".green
        puts "Path:           #{Dir.pwd}".green
        puts "Redis:          #{Scales.config.host}:#{Scales.config.port}/#{Scales.config.database}".green
        
        @total, @done = paths.size, 0
        paths.each do |path|
          print "Pushing paths:  #{progress}% (#{@done}/#{@total})".green
          process_push!(path)
          print "\r"
        end
        
        puts "Pushing paths:  #{progress}% (#{@done}/#{@total})".green
        puts "Done.".green
      end
      
      private
      
      def push_response(path, response)
        Storage::Sync.set_content(path[:to], response) 
        data = {
          :path   => path[:to],
          :format => path[:format].to_s.upcase,
          :type   => "push_#{Cache.resource_or_partial?(path[:to])}"
        }
        Storage::Sync.connection.publish "scales_monitor_events", data.to_json
      end
    end
  end
end