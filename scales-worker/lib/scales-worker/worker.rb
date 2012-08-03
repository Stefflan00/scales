module Scales
  module Worker
    class Worker
      attr_reader :app
      attr_reader :type
      attr_reader :pool
      attr_reader :status
    
      def initialize(type = Application::Rails)
        @type, @app, @status, @pool = type, type.app, Status.new("localhost"), []
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
        rescue Exception => e
          [id, [500, {}, e.to_s]]
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
      def process_request!
        job = Thread.current[:redis_blocking].brpop(Scales::Storage::REQUEST_QUEUE, 0).last
        id, response = nil, nil
        
        Thread.current[:post_process_queue] = []
        id, response = process!(job)
        post_process!(job)
        @status.put_response_in_queue!(response)
        Thread.current[:redis_nonblocking].publish(Scales::Storage::RESPONSE_CHANNEL, JSON.generate(response))
        
        [id, response]
      end
      
      def start_pool!(size = Scales.config.worker_threads)
        Thread.abort_on_exception = true
        size.times do
          @pool << Thread.new do
            Thread.current[:redis_blocking]     = Scales::Storage::Sync.new_connection!
            Thread.current[:redis_nonblocking]  = Scales::Storage::Sync.new_connection!
            loop do
              begin
                process_request!
              rescue Exception => e
                @status.logger.error(e.to_s)
                raise e if Scales.env == "test"
              end
            end
          end
        end
        sleep
      end
      
      # Loop the processing of requests
      def work!
        @status.start!
        
        puts "Environment:    #{Scales.env}".green
        puts "Application:    #{@type.name}".green
        puts "Path:           #{Dir.pwd}".green
        puts "Log Path:       #{@status.log_path}".green
        puts "Threads:        #{Scales.config.worker_threads}".green
        puts "Redis:          #{Scales.config.host}:#{Scales.config.port}/#{Scales.config.database}".green
        
        begin
          start_pool!
        rescue Interrupt => e
          @pool.map(&:exit)
          puts "Goodbye".green
        end
      end
    
    end
  end
end