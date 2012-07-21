module Scales
  module Worker
    module Path
      class << self
    
        def to_env(path, env)
          {
            "CONTENT_TYPE"=>env["CONTENT_TYPE"], 
            "GATEWAY_INTERFACE"=>"CGI/1.1", 
            "PATH_INFO"=>path, 
            "QUERY_STRING"=>"", 
            "REMOTE_ADDR"=>"127.0.0.1", 
            "REMOTE_HOST"=>"loopback", 
            "REQUEST_METHOD"=>"GET", 
            "REQUEST_URI"=>"http://localhost#{path}", 
            "SCRIPT_NAME"=>"", 
            "SERVER_NAME"=>"localhost", 
            "SERVER_PORT"=>"80", 
            "SERVER_PROTOCOL"=>"HTTP/1.1", 
            "SERVER_SOFTWARE"=>"Scales-Worker #{Scales::Worker::VERSION}", 
            "HTTP_HOST"=>"localhost", 
            "HTTP_USER_AGENT"=>"Scales-Worker #{Scales::Worker::VERSION}", 
            "HTTP_ACCEPT"=>env["HTTP_ACCEPT"], 
            "HTTP_ORIGIN"=>"http://localhost", 
            "HTTP_AUTHORIZATION"=>env["HTTP_AUTHORIZATION"], 
            "HTTP_REFERER"=>env["HTTP_REFERER"], 
            "HTTP_ACCEPT_LANGUAGE"=>env["HTTP_ACCEPT_LANGUAGE"], 
            "HTTP_ACCEPT_ENCODING"=>env["HTTP_ACCEPT_ENCODING"], 
            "HTTP_COOKIE"=>env["HTTP_COOKIE"], 
            "HTTP_CONNECTION"=>"keep-alive", 
            "rack.version"=>[1, 1], 
            "rack.input"=>StringIO.new,
            "rack.multithread"=>false, 
            "rack.multiprocess"=>false, 
            "rack.run_once"=>false, 
            "rack.url_scheme"=>"http", 
            "HTTP_VERSION"=>"HTTP/1.1", 
            "REQUEST_PATH"=>path, 
            "ORIGINAL_FULLPATH"=>path
          }
        end
    
      end
    end
  end
end