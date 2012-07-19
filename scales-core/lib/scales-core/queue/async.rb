module Scales
  module Queue
    module Async
      class << self
        
        def add(job)
          Storage::Async.add(Queue::NAME, job)
        end
        
        def pop
          Storage::Async.pop(Queue::NAME)
        end
        
      end
      
    end
  end
end