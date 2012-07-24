module Scales
  module Config
    require 'ostruct'
    
    DEFAULTS = {
      :host     => "localhost",
      :port     => 6379,
      :password => nil,
      :database => 0
    }
    
    CONFIG_PATHS = ['config/cache.yml', 'cache.yml']
    
    class << self
      
      def config
        @@config ||= load! || OpenStruct.new(DEFAULTS)
      end
      
      def reset!
        @@config = nil
      end
      
      def load!
        load_paths = CONFIG_PATHS.map{ |path| File.exists?(path) }
        return unless load_paths.any?
        
        cache   = CONFIG_PATHS[load_paths.index(true)]
        config  = YAML.load_file(cache)[Scales.env]
        
        OpenStruct.new(config)
      end
      
    end
  end
end