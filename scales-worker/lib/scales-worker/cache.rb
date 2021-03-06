module Scales
  module Worker
    module Cache
      autoload :HTML,     "scales-worker/cache/html"
      autoload :JSON,     "scales-worker/cache/json"
      autoload :XML,      "scales-worker/cache/xml"
      autoload :Push,     "scales-worker/cache/push"
      autoload :Destroy,  "scales-worker/cache/destroy"
      autoload :Update,   "scales-worker/cache/update"
      
      class << self
        
        def class_for params_or_format
          params = params_or_format.is_a?(Symbol) ? { params_or_format => nil } : params_or_format
          
          return HTML if params.keys.include?(:html)
          return JSON if params.keys.include?(:json)
          return XML  if params.keys.include?(:xml)
        end
        
        def resource_or_partial?(path)
          (path =~ /^\//) ? "resource" : "partial"
        end
        
      end
    end
  end
end