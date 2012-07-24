module Scales
  class << self

    def config
      Config.config
    end
    
    def env
      ENV['SCALES_ENV']
    end
    
    def env=(env)
      ENV['SCALES_ENV'] = env
    end
    
  end
end