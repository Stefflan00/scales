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
    
    def push(content, params)
      Worker::Cache::Push.push(content, params)
    end
    alias_method :set, :push
    
    def destroy(path)
      Worker::Cache::Destroy.destroy(path)
    end
    alias_method :delete, :destroy
    alias_method :remove, :destroy
    alias_method :wipe,   :destroy
    
    def update(*paths)
      Worker::Cache::Update.update(*paths)
    end
    alias_method :reload,  :update
    alias_method :refresh, :update
    alias_method :repush,  :update
    
  end
end