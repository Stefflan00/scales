module Scales
  module Worker
    class Worker
      attr_reader :app
      attr_reader :type
    
      def initialize(type = Application::Rails)
        @type, @app, @status = type, type.app, Status.new("localhost")
        at_exit{ @status.stop! }
      end
      
      def parse(job)
        Job.to_env(job)
      end
      
      def process!(job)
        env = parse(job)
        id  = env['scales.id']
        
        @status.took_request_from_queue!(env)
        
        begin
          response  = @app.call(env)
          response.last.close if response.last.respond_to?(:close)
          [id, Response.to_job(id, response)]
        rescue
          [id, [500, {}, ""]]
        end
      end
      
      def post_process!(job)
        env = parse(job)
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
      
      # Wait for a request, process it, publish the response and exit
      def process_request!(should_wait_for_request_to_finish = false)
        job = Scales::Queue::Sync.pop
        id, response = nil, nil
        
        Thread.abort_on_exception = true
        thread = Thread.new do
          Thread.current[:post_process_queue] = []
          id, response = process!(job)
          post_process!(job)
          @status.put_response_in_queue!(response)
          Scales::PubSub::Sync.publish("scales_response_#{id}", JSON.generate(response))
        end
        
        thread.join if should_wait_for_request_to_finish
        
        [id, response]
      end
      
      # Loop the processing of requests
      def work!
        @status.start!
        
        puts "Environment:    #{Scales.env}".green
        puts "Application:    #{@type.name}".green
        puts "Path:           #{Dir.pwd}".green
        puts "Redis:          #{Scales.config.host}:#{Scales.config.port}/#{Scales.config.database}".green
        
        begin
          loop{ process_request! }
        rescue Interrupt => e
          puts "Goodbye".green
        end
      end
    
    end
  end
end