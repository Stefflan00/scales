module Scales
  module Server
    module Dispatch
      module Response
        class << self
          
          @@redis       = nil
          @@subscribers = {}
          @@subscribed  = false
          
          def subscribe(id)
            setup_subscription!
            @@subscribers[id] = Fiber.current
            Fiber.yield
          end
          
          def reset!
            @@redis       = nil
            @@subscribers = {}
            @@subscribed  = false
          end
          
          private
          
          def connect!
            return if @@redis and @@redis.connected?
            @@redis = Storage::Async.new_connection!
          end
          
          def setup_subscription!
            connect!
            return if @@subscribed

            @@redis.subscribe("scales_response_channel")
            @@redis.on(:message) do |channel, message|
              response  = Job.to_response(message)
              id        = response[1]['scales.id']
              
              fiber = @@subscribers.delete(id)
              fiber.resume(response) if fiber
            end
            @@subscribed = true
          end
          
        end
      end
    end
  end
end