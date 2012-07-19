module ScalesApplication
  module Rails
    class << self
      
      def app
        application_name::Application.initialize!
      end
      
      private
      
      def application_name
        before_modules = Object.constants
        
        require './config/application.rb'
        
        after_modules  = Object.constants
        delta_modules  = after_modules - before_modules
        Kernel.const_get(delta_modules.last)
      end
      
    end
  end
end