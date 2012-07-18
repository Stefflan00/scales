module Scales
  module Dispatch
    autoload :Lookup, "scales/dispatch/lookup"
     
    class << self
      
      def request(env)
        return Lookup.ressource(env) if is_get_request?(env)
        [200, {}, "Test"]
      end
      
      private
      
      def is_get_request?(env)
        env["REQUEST_METHOD"] == "GET"
      end
      
    end
  end
end