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
            Storage::Sync.set(path, content)
            content
          end
        
        end
      end
    end
  end
end