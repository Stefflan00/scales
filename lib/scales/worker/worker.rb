module Scales
  module Worker
    
    class Worker
      include AppLoader
      
      attr_reader :app
      
      def initialize
        load_app!
      end
      
    end
    
  end
end