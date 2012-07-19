module Scales
  module Queue
    module Sync
      class << self
        
        def add(job)
          Storage::Sync.add(Queue::NAME, job)
        end
        
        def pop
          Storage::Sync.pop(Queue::NAME)
        end
        
      end
      
    end
  end
end