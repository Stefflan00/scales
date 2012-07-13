module Scales
  module Queue
    module Sync
            
      module Base
        def key(key)
          @key = key
        end
        
        def add(job)
          Scales::Storage::Sync.add(@key, job)
        end
        
        def pop
          Scales::Storage::Sync.pop(@key)
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