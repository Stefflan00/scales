module Scales
  module Config
    require 'ostruct'
    
    DEFAULTS = {
      :redis_host => "localhost",
      :redis_port => 6379
    }
    
    class << self
      
      def config
        @@config ||= OpenStruct.new(DEFAULTS)
      end
      
    end
  end
end