module Scales
  module Storage
    REQUEST_QUEUE     = "scales_request_queue"
    RESPONSE_CHANNEL  = "scales_response_channel"
    RESOURCE_PREFIX   = "scales_resource_"
    PARTIAL_PREFIX    = "scales_partial_"

    autoload :Sync,   "scales-core/storage/sync"
    autoload :Async,  "scales-core/storage/async"
    
    class << self
      
      def prefix(path)
        (path =~ /^\//) ? RESOURCE_PREFIX + path : PARTIAL_PREFIX + path
      end
      
    end
  end
end