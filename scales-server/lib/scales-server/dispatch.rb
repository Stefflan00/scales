module Scales
  module Server
    module Dispatch
      autoload :Lookup,   "scales-server/dispatch/lookup"
      autoload :Enqueue,  "scales-server/dispatch/enqueue"
      autoload :Request,  "scales-server/dispatch/request"
      autoload :Job,      "scales-server/dispatch/job"
     
      class << self
      
        def request(env)
          if is_get_request?(env) then Lookup.ressource(env) else Enqueue.request(env) end
        end
      
        private
      
        def is_get_request?(env)
          env["REQUEST_METHOD"] == "GET"
        end
      
      end
    end
  end
end