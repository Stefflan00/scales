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
    
    def append(params)
      Worker::Cache.class_for(params).append(params)
    end
    
    def prepend(params)
      Worker::Cache.class_for(params).prepend(params)
    end
    
    def set(params)
      Worker::Cache.class_for(params).set(params)
    end
    
    def replace(params)
      Worker::Cache.class_for(params).replace(params)
    end
    
    def remove(format, params)
      Worker::Cache.class_for(format).remove(params)
    end
    
    def destroy(*paths)
      Worker::Cache::Destroy.destroy(*paths)
    end
    
    def update(*paths, params)
      Worker::Cache::Update.update(*paths, params)
    end
    
    def get(path)
      Storage::Sync::get_content(path)
    end
        
  end
end