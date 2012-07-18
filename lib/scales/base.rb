module Scales
  
  # Hook in first level methods
  class << self
    
    def config
      Config.config
    end
    
  end
end