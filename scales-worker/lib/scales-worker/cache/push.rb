module Scales
  module Worker
    module Cache
      module Push
        class << self
        
          def push(content, params = {})
            path = params[:to] || params[:at]
            raise "Don't know where to push, missing :to => '/a/path' parameter" if path.nil?
            Storage::Sync.set(path, content)
          end
        
        end
      end
    end
  end
end