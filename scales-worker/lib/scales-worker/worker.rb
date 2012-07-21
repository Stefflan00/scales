module Scales
  module Worker
    class Worker
      attr_reader :app
      attr_reader :type
    
      def initialize(type = Application::Rails)
        @type, @app = type, type.app
      end
      
      def parse(job)
        Job.to_env(job)
      end
      
      def process!(job)
        env = parse(job)
        id  = env['scales.id']
        
        begin
          response  = @app.call(env)
          response.last.close
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
            response.last.close
          rescue
          end
        end
      end
      
      # Wait for a request, process it, publish the response and exit
      def process_request!(should_wait_for_request_to_finish = false)
        job = Scales::Queue::Sync.pop
        id, response = nil, nil
        
        thread = Thread.new do
          Thread.current[:post_process_queue] = []
          id, response  = process!(job)
          post_process!(job)
          Scales::PubSub::Sync.publish(id, JSON.generate(response))
        end
        
        thread.join if should_wait_for_request_to_finish
        
        [id, response]
      end
      
      # Loop the processing of requests
      def work!
        begin
          puts "Started working with #{@type.name} from #{Dir.pwd}".green
          loop{ process_request! }
        rescue Interrupt => e
          puts "Goodbye".green
        end
      end
    
    end
  end
end