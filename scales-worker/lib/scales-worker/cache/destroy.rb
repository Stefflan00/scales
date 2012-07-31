module Scales
  module Worker
    module Cache
      module Destroy
        class << self
        
          def destroy(*paths)
            paths.each do |path|
              publish_destroy(path)
              Storage::Sync.del(path)
            end
          end
          
          private
          
          def publish_destroy(path)
            key_or_partial = (path =~ /^\//) ? "key" : "partial"
            data = {
              :path   => path,
              :type   => "destroy_#{key_or_partial}"
            }
            Storage::Sync.connection.publish "scales_monitor_events", data.to_json
          end
          
        end
      end
    end
  end
end