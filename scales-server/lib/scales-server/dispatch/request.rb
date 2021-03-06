module Scales
  module Server
    module Dispatch
      module Request
        class << self
      
          def to_job(id, env)
            scales_variables  = { 'scales.id' => id }
            request_variables = env.dup.keep_if{ |key, value| [
              'REQUEST_METHOD',
              'PATH_INFO',
              'QUERY_STRING',
              'SERVER_NAME',
              'SERVER_PORT'
            ].include?(key) }
            http_variables    = env.dup.keep_if{ |key, value| key.match /^HTTP_/  }
            rack_variables    = {
              'rack.version'      => env['rack.version'],
              'rack.url_scheme'   => env['rack.url_scheme'],
              'rack.input'        => env['rack.input'].string
            }
            scales_variables.merge(request_variables).merge(http_variables).merge(rack_variables)
          end
          
        end
      end
    end
  end
end