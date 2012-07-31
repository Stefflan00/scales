module Scales
  module Worker
    module Cache
      module Destroy
        class << self
        
          def destroy(*paths)
            paths.each do |path|
              key_or_partial = Cache.key_or_partial_for(path)
              publish_destroy(path, key_or_partial)
              key_or_partial == "key" ? Storage::Sync.del_content(path) : Storage::Sync.del_content(path)
            end
          end
          
          private
          
          def publish_destroy(path, key_or_partial)
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