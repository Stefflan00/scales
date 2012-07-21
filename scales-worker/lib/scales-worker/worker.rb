module Scales
  module Worker
    class Worker
      attr_reader :app
      attr_reader :threads
    
      def initialize(application = Application::Rails)
        @app, @threads = application.app, []
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
      
      # Wait for a request, process it, publish the response and exit
      def process_request!(should_wait_for_request_to_finish = false)
        job = Scales::Queue::Sync.pop
        id, response = nil, nil
        
        thread = Thread.new do
          id, response  = process!(job)
          Scales::PubSub::Sync.publish(id, JSON.generate(response))
        end
        
        thread.join if should_wait_for_request_to_finish
        
        [id, response]
      end
      
      # Loop the processing of requests
      def work!
        loop{ process_request! }
      end
    
    end
  end
end