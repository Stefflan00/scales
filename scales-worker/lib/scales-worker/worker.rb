module Scales
  module Worker
    class Worker
      attr_reader :app
    
      def initialize(application = Application::Rails)
        @app = application.app
      end
      
      def parse(job)
        Job.to_env(job)
      end
      
      def process!(job)
        env       = parse(job)
        id        = env['scales.id']
        response  = @app.call(env)
        response.last.close
        
        [id, Response.to_job(id, response)]
      end
      
      # Wait for a request, process it, publish the response and exit
      def process_request!
        job           = Scales::Queue::Sync.pop
        id, response  = process!(job)
        
        Scales::PubSub::Sync.publish(id, JSON.generate(response))
        
        [id, response]
      end
      
      # Loop the processing of requests
      def work!
        loop{ process_request! }
      end
    
    end
  end
end