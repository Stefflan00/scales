module Scales
  module Monitor
    
    PUBLIC_APP_DIR = File.expand_path("../app/public", __FILE__)
    
    module Monitor
      
      @@cache = nil
      
      class << self
        
        def serve(path)
          cache_files! if @@cache.nil?
          @@cache[path]
        end
        
        private
        
        def cache_files!
          @@cache = {}
          
          Dir.chdir(PUBLIC_APP_DIR)
          Dir["*.html", "assets/*"].each{ |file| @@cache["/#{file}"] = File.read(file) }
          
          @@cache["/"] = @@cache["/index.html"]
        end
        
      end
      
    end
  end
end