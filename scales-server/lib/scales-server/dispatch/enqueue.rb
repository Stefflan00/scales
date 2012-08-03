module Scales
  module Server
    module Dispatch
      module Enqueue
        class << self
      
          def request(env)
            id  = create_random_id
            job = Request.to_job(id, env)
            
            Scales::Server.status.put_request_in_queue!(job)
            Storage::Async.add(Storage::REQUEST_QUEUE, JSON.generate(job))
          
            response = Response.subscribe(id)
            Scales::Server.status.took_response_from_queue!(response)
            response
          end
        
          private
        
          def create_random_id
            id = SecureRandom.hex(16)
            Storage::Async.connection.set("test_last_request_id", id) if Goliath.env == :test
            id
          end
      
        end
      end
    end
  end
end