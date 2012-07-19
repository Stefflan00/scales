module Scales
  module Server
    module Dispatch
      module Job
        class << self
      
          def to_request(env)
            {}
          end
        
          def to_response(response)
            JSON.parse(response)
          end
      
        end
      end
    end
  end
end