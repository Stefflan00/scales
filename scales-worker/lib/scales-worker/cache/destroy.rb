module Scales
  module Worker
    module Cache
      module Destroy
        class << self
        
          def destroy(*paths)
            paths.each{ |path| Storage::Sync.del(path) }
          end
        
        end
      end
    end
  end
end