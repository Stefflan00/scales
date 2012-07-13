module Scales
  module Queue
    module Async
            
      module Base
        def key(key)
          @key = key
        end
        
        def add(job)
          Scales::Storage::Async.add(@key, job) do
            yield if block_given?
          end
        end
        
        def pop
          Scales::Storage::Async.pop(@key) do |value|
            yield(value)
          end
        end
      end
      
      
      module Request
        extend Base
        key "scales_request_queue"
      end
      
      module Response
        extend Base
        key "scales_response_queue"
      end
      
    end
  end
end