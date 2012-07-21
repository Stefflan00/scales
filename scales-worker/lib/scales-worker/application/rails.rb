module Scales
  module Worker
    module Application
      module Rails
        class << self
        
          @@app = nil
    
          def app
            @app ||= initialize_app!
          end
          
          def name
            "Rails application #{@app.class.to_s.split("::").first}"
          end
    
          private
        
          def initialize_app!
            before_modules = Object.constants
            require './config/application.rb'
            after_modules  = Object.constants
            delta_modules  = after_modules - before_modules
          
            Kernel.const_get(delta_modules.last)::Application.initialize!
          end
    
        end
      end
    end
  end
end