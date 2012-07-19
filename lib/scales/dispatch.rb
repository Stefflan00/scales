module Scales
  module Dispatch
    autoload :Lookup,   "scales/dispatch/lookup"
    autoload :Enqueue,  "scales/dispatch/enqueue"
    autoload :Request,  "scales/dispatch/request"
    autoload :Job,      "scales/dispatch/job"
     
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