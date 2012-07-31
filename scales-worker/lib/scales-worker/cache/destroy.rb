module Scales
  module Worker
    module Cache
      module Destroy
        class << self
        
          def destroy(*paths)
            paths.each do |path|
              publish_destroy(path)
              Storage::Sync.del_content(path)
            end
          end
          
          private
          
          def publish_destroy(path)
            data = {
              :path   => path,
              :type   => "destroy_#{Cache.resource_or_partial?(path)}"
            }
            Storage::Sync.connection.publish "scales_monitor_events", data.to_json
          end
          
        end
      end
    end
  end
end