module Scales
  module Helper
    module BeforeFilter

      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods

        @@filters = []

        def before_filter filter
          @@filters << filter
        end

        def singleton_method_added(name)
          return if @@filters.include?(name)
          return if @history && @history.include?(name)

          with      = :"#{name}_with_before_filter"
          without   = :"#{name}_without_before_filter"
          @history  = [name, with, without]
          metaclass = class << self
            self
          end

          metaclass.class_eval do

            define_method with do |*args, &block|
              @@filters.each{ |filter| send filter }
              send without, *args, &block
            end

            alias_method without, name
            alias_method name, with
          end

          @history = nil
        end
      end  
    end
  end
end