module Scales
  module Worker
    module Application
      module Rails
        ENV['RAILS_ENV'] ||= "development"
        
        class << self
        
          @@app = nil
        
          def initialize_app!
            @@app ||= load_application.initialize!
            raise "Could not load Rails Application" if @@app.nil?
            @@app
          end
          alias_method :app,                      :initialize_app!
          alias_method :initialize_environment!,  :initialize_app!
          
          def name
            "Rails #{app.class.to_s.split("::").first} (#{ENV['RAILS_ENV']})"
          end
    
          private
          
          def load_application
            before_modules = Object.constants
            require './config/application.rb'
            after_modules  = Object.constants
            delta_modules  = after_modules - before_modules
            
            Kernel.const_get(delta_modules.last)::Application
          end
    
        end
      end
    end
  end
end