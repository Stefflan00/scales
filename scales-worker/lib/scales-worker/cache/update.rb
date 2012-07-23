module Scales
  module Worker
    module Cache
      module Update
        include Helper::ContentTypes
        
        class << self
        
          def update(*paths, params)
            raise "Please define a format like this :format => :html" unless params.is_a?(Hash)
            format = params.delete(:format)
            raise "Unknown format :#{format}"                         if format.to_content_type.nil?
            paths.each{ |path| Thread.current[:post_process_queue] << { :format => format, :to => path }}
          end
        
        end
      end
    end
  end
end