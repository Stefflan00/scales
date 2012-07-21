module Scales
  module Worker
    module Cache
      module Update
        class << self
        
          def update(*paths)
            paths.each{ |path| Thread.current[:post_process_queue] << path }
          end
        
        end
      end
    end
  end
end