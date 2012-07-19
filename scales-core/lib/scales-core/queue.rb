module Scales
  module Queue
    NAME = "scales_request_queue"
    
    autoload :Sync,   "scales-core/queue/sync"
    autoload :Async,  "scales-core/queue/async"
  end
end