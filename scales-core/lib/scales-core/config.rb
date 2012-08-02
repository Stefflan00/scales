module Scales
  module Config
    require 'ostruct'
    
    DEFAULTS = {
      :host           => "localhost",
      :port           => 6379,
      :password       => nil,
      :database       => 0,
      :partials       => false,
      :worker_threads => 30
    }
    
    @@pwd = "."
    CONFIG_PATHS  = ['config/cache.yml', 'cache.yml']
    
    class << self
      
      def config
        @@config ||= OpenStruct.new DEFAULTS.merge(load!)
      end
      
      def reset!
        @@config = nil
      end
      
      def load!
        load_paths = CONFIG_PATHS.map{ |path| File.exists?(File.join(@@pwd, path)) }
        return {} unless load_paths.any?
        
        cache   = File.join(@@pwd, CONFIG_PATHS[load_paths.index(true)])
        config  = YAML.load_file(cache)[Scales.env]
        
        Hash[config.map{|(k,v)| [k.to_sym,v]}]
      end
      
      def pwd=(pwd)
        @@pwd = pwd
      end
      
      def pwd
        @@pwd
      end
      
    end
  end
end