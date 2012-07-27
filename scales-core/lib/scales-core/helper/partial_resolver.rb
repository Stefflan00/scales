module Scales
  module Helper
    module PartialResolver
      
      PARTIAL_REGEX = /(Scales\.partial ["|'](.*)["|'])/
      
      class << self
        
        def resolve(redis, key)
          value = redis.get(key)
          
          i = 0
          
          while includes_partial?(value) do
            value = resolve_partial(redis, value)
          end
          value
        end
        
        def includes_partial?(value)
          value =~ PARTIAL_REGEX
        end
        
        def resolve_partial(redis, value)
          matched = value.match(PARTIAL_REGEX)
          tag, key = matched[1], matched[2]
          partial = redis.get(key)
          
          value.gsub(tag, partial)
        end
        
      end
      
    end
  end
end