module Scales
  module Server
    
    class ContentType
      include Goliath::Rack::AsyncMiddleware
    
      TYPES = Scales::Helper::ContentTypes::TYPES
    
      def initialize(app, format = 'html')
        @app, @format = app, format
      end

      def post_process(env, status, headers, body)
        headers['Content-Type'] = parse_from_format?(env['REQUEST_URI'])
        [status, headers, body]
      end
    
      def parse_from_format?(uri)
        content_type = TYPES[@format.to_sym]
        TYPES.each { |format, type| content_type = type and break if uri =~ /\.#{format}(\?|$)/ }
        content_type
      end
    end
    
  end
end