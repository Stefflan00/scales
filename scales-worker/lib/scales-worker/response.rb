module Scales
  module Worker
    module Response
      class << self
    
        def to_job(id, response)
          status, headers, chunked_body = response
          
          headers = headers.dup.keep_if do |key, value|
            key.match /^HTTP_/ or
            [
              'Location', 
              'Content-Type', 
              'Set-Cookie',
              'REQUEST_METHOD',
              'SCRIPT_NAME',
              'PATH_INFO',
              'QUERY_STRING',
              'SERVER_NAME',
              'SERVER_PORT'
            ].include?(key)
          end
          headers['scales.id'] = id
          
          body = ""
          chunked_body.each{ |chunk| body << chunk }
          
          [status, headers, body]
        end
    
      end
    end
  end
end