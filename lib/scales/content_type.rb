module Scales
  class ContentType
    include Goliath::Rack::AsyncMiddleware
    
    TYPES = {
      'html'  => 'text/html',
      'htm'   => 'text/html',
      'txt'   => 'text/plain',
      'css'   => 'text/css',
      'yaml'  => 'text/yaml',
      'js'    => 'application/javascript',
      'json'  => 'application/json',
      'rss'   => 'application/rss+xml',
      'xml'   => 'application/xml',
      'pdf'   => 'application/pdf'
    }
    
    def initialize(app, format = 'html')
      @app = app
      @format = format
    end

    def post_process(env, status, headers, body)
      headers['Content-Type'] = parse_from_format?(env['REQUEST_URI'])
      [status, headers, body]
    end
    
    def parse_from_format?(uri)
      content_type = TYPES[@format]
      TYPES.each { |format, type| content_type = type and break if uri =~ /\.#{format}$/ }
      content_type
    end
  end
end