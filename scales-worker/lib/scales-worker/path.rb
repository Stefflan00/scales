module Scales
  module Worker
    module Path
      include Helper::ContentTypes
      
      class << self
        
        def parse_path(original_path)
          path, query = original_path.split "?"
          [original_path, path, query]
        end
        
        def with_options_to_env(options)
          full, path, query = parse_path(options[:to])
          content_type      = options[:format].to_content_type
          
          {
            "GATEWAY_INTERFACE"=>"CGI/1.1",
            "CONTENT_TYPE" => content_type,
            "PATH_INFO"=>path,
            "QUERY_STRING"=>query,
            "REMOTE_ADDR"=>"127.0.0.1",
            "REMOTE_HOST"=>"loopback",
            "REQUEST_METHOD"=>"GET",
            "REQUEST_URI"=>"http://localhost:3000#{full}",
            "SCRIPT_NAME"=>"",
            "SERVER_NAME"=>"localhost",
            "SERVER_PORT"=>"3000",
            "SERVER_PROTOCOL"=>"HTTP/1.1",
            "SERVER_SOFTWARE"=>"Scales-Server #{Scales::Worker::VERSION}",
            "HTTP_HOST"=>"localhost:3000",
            "HTTP_USER_AGENT"=>"Scales-Worker #{Scales::Worker::VERSION}",
            "HTTP_ACCEPT"=>"*/*",
            "HTTP_COOKIE"=>"",
            "HTTP_ACCEPT_LANGUAGE"=>"en-us",
            "HTTP_ACCEPT_ENCODING"=>"gzip, deflate",
            "HTTP_CONNECTION"=>"keep-alive",
            "rack.version"=>[1, 1],
            "rack.input"=>StringIO.new,
            "rack.multithread"=>false,
            "rack.multiprocess"=>false,
            "rack.run_once"=>false,
            "rack.url_scheme"=>"http",
            "HTTP_VERSION"=>"HTTP/1.1",
            "REQUEST_PATH"=>path,
            "ORIGINAL_FULLPATH"=>full
          }
        end
    
        def to_env(options, env)
          full, path, query = parse_path(options[:to])
          content_type      = options[:format].to_content_type rescue env["CONTENT_TYPE"]
          {
            "GATEWAY_INTERFACE"=>"CGI/1.1",
            "CONTENT_TYPE" => content_type,
            "PATH_INFO"=>path,
            "QUERY_STRING"=>query,
            "REMOTE_ADDR"=>"127.0.0.1",
            "REMOTE_HOST"=>"loopback",
            "REQUEST_METHOD"=>"GET",
            "REQUEST_URI"=>"http://localhost:3000#{full}",
            "SCRIPT_NAME"=>"",
            "SERVER_NAME"=>"localhost",
            "SERVER_PORT"=>"3000",
            "SERVER_PROTOCOL"=>"HTTP/1.1",
            "SERVER_SOFTWARE"=>"Scales-Server #{Scales::Worker::VERSION}",
            "HTTP_HOST"=>"localhost:3000",
            "HTTP_USER_AGENT"=>"Scales-Worker #{Scales::Worker::VERSION}",
            "HTTP_ACCEPT"=>"*/*",
            "HTTP_COOKIE"=>env["HTTP_COOKIE"],
            "HTTP_ACCEPT_LANGUAGE"=>env["HTTP_ACCEPT_LANGUAGE"],
            "HTTP_ACCEPT_ENCODING"=>env["HTTP_ACCEPT_ENCODING"],
            "HTTP_CONNECTION"=>"keep-alive",
            "rack.version"=>[1, 1],
            "rack.input"=>StringIO.new,
            "rack.multithread"=>false,
            "rack.multiprocess"=>false,
            "rack.run_once"=>false,
            "rack.url_scheme"=>"http",
            "HTTP_VERSION"=>"HTTP/1.1",
            "REQUEST_PATH"=>path,
            "ORIGINAL_FULLPATH"=>full
          }
        end
    
      end
    end
  end
end