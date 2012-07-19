module Scales
  module Worker
    module AppLoader
      
    def load_app!
      DRb.start_service
      @app = DRbObject.new_with_uri(ScalesApplication::URI)
    end
      
    end
  end
end