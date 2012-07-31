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
            key_or_partial = Cache.key_or_partial_for(path)
            
            publish_push(path, format, key_or_partial)                                    
            key_or_partial == "key" ? Storage::Sync.set_content(path, content) : Storage::Sync.set_content(path, content)
            content
          end
          
          private
          
          def publish_push(path, format, key_or_partial)
            data = {
              :path   => path,
              :format => format.to_s.upcase,
              :type   => "push_#{key_or_partial}"
            }
            Storage::Sync.connection.publish "scales_monitor_events", data.to_json
          end
        
        end
      end
    end
  end
end