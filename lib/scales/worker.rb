module Scales
  module Worker
    autoload :AppLoader,  "scales/worker/app_loader"
    autoload :Worker,     "scales/worker/worker"
    
    class << self
      def run!
        Worker.new
      end
    end
  end
end