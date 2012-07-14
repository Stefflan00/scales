module Scales
  module Lookup
    class << self
      
      def ressource(env)
        response = Storage::Async.get(path(env))
        response.nil? ? render_not_found : render(response)
      end
      
      private
      
      def path(env)
        env["REQUEST_URI"]
      end
      
      def render_not_found
        [404, {}, ""]
      end
      
      def render(response)
        [200, {}, response]
      end
      
    end
  end
end