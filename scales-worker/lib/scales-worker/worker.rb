module Scales
  module Worker
    class Worker
      attr_reader :app
    
      def initialize(application = Application::Rails)
        @app = application.app
      end
    
    end
  end
end