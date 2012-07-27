module Scales
  class << self

    def config
      Config.config
    end
    
    def env
      ENV['SCALES_ENV'] ||= "development"
    end
    
    def env=(env)
      ENV['SCALES_ENV'] = env
    end
    
    def try_to_setup_env!
      return if ARGV.empty?
      return if ARGV.first =~ /^\-/
      Scales.env = ARGV.pop
    end
    
  end
end