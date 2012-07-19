module Scales
  module Queue
    NAME = "scales_request_queue"
    
    autoload :Sync,   "scales/queue/sync"
    autoload :Async,  "scales/queue/async"
  end
end