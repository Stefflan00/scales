module Scales
  module Server
    module Dispatch
      module Lookup
        class << self
      
          def resource(env)
            response = Storage::Async.get_content(path(env), Scales.config.partials)
            response.nil? ? render_not_found : render(response)
          end
      
          private
      
          def path(env)
            env["REQUEST_URI"]
          end
      
          def render_not_found
            [404, {}, "Not found"]
          end
      
          def render(response)
            [200, {}, response]
          end
      
        end
      end
    end
  end
end