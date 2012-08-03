module Scales
  module Server
    module Proxy
      
      module Callbacks
        extend  self

        def on_connect
        end

        def on_data
          lambda { |data| data }
        end

        def on_response
          lambda { |backend, response|  response }
        end

        def on_select
          lambda { |backend| backend.increment_counter if Backend.strategy == :balanced }
        end

        def on_finish
          lambda { |backend| backend.decrement_counter if Backend.strategy == :balanced }
        end

      end
      
    end
  end
end