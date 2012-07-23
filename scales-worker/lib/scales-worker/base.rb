module Scales
  module Worker
    class << self
      
      def run!
        Worker.new.work!
      end
      
    end
  end
  
  # Cache Methods
  class << self
    
    def push(params)
      Worker::Cache::Push.push(params)
    end
    
    def destroy(*paths)
      Worker::Cache::Destroy.destroy(*paths)
    end
    
    def update(*paths, params)
      Worker::Cache::Update.update(*paths, params)
    end
    
  end
end