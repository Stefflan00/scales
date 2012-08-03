module Scales
  module Server
    module Proxy      
      autoload :Backend,    "scales-server/proxy/backend"
      autoload :Callbacks,  "scales-server/proxy/callbacks"
      
      class << self
        
        def run!(host = '0.0.0.0', port = 9999)
          
          puts "Proxy Port:     #{port}".green
          puts "Server Ports:   #{Backend.ports.join(', ')}".green
          
          ::Proxy.start(:host => host, :port => port, :debug => false) do |connection|

            Backend.select do |backend|
              connection.server backend, :host => backend.host, :port => backend.port

              connection.on_connect  &Callbacks.on_connect
              connection.on_data     &Callbacks.on_data
              connection.on_response &Callbacks.on_response
              connection.on_finish   &Callbacks.on_finish
            end

          end
        end
        
      end
    end
  end
end