module Scales
  module Server
    module Dispatch
      module Enqueue
        class << self
      
          def request(env)
            id  = create_random_id
            job = Request.to_job(id, env)
          
            Queue::Async.add(JSON.generate(job))
          
            response = PubSub::Async.subscribe("scales_response_#{id}")
            Job.to_response(response)
          end
        
          private
        
          def create_random_id
            id = SecureRandom.hex(16)
            Storage::Async.set("test_last_request_id", "scales_response_#{id}") if Goliath.env == :test
            id
          end
      
        end
      end
    end
  end
end