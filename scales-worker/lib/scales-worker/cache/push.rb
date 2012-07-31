module Scales
  module Worker
    module Cache
      module Push
        include Helper::ContentTypes
        
        class << self
        
          def push(params = {})
            path = params.delete(:to)
            format, content = params.to_a.first
            raise "Don't know where to push, missing :to => '/a/path' parameter"  if path.nil?
            raise "Unknown format :#{format}"                                     if format.to_content_type.nil?
            
            publish_push(path, format)                                    
            Storage::Sync.set_content(path, content)
            content
          end
          
          private
          
          def publish_push(path, format)
            data = {
              :path   => path,
              :format => format.to_s.upcase,
              :type   => "push_#{Cache.resource_or_partial?(path)}"
            }
            Storage::Sync.connection.publish "scales_monitor_events", data.to_json
          end
        
        end
      end
    end
  end
end