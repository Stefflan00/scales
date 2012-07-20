module Scales
  module Worker
    class << self
      
      def run!
        Worker.new.work!
      end
      
    end
  end
end