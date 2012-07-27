module Scales
  module Storage
    module ReservedKeys
      @@expressions = [/^scales\_/]
      
      class << self
        
        def expressions
          @@expressions
        end
        
        def add(expression)
          @@expressions << expression
        end
        
        def validate!(key)
          raise "#{key} is a reserved key, please choose another one!" if @@expressions.map{ |expression| key =~ expression }.any?
        end
        
      end
    end
  end
end