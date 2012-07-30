module Scales
  module Server
    
    class Status
      attr_reader :key, :id, :address, :port
      
      def initialize address, port
        @id   = SecureRandom.hex(8)
        @key  = "scales_server_#{@id}"
        @address, @port = address.to_s, port.to_s
      end
      
      def start!
        data  = {
          :id         => @id,
          :key        => @key,
          :type       => "server_started",
          :spawned_at => Time.now.to_i,
          :env        => Scales.env,
          :ip         => @address,
          :port       => @port
        }
        json = JSON.generate(data)
        
        Storage::Sync.connection.set(@key, json)
        Storage::Sync.connection.publish("scales_monitor_events", json)
      end
      
      def stop!
        data  = {
          :id         => @id,
          :key        => @key,
          :type       => "server_stopped"
        }
        json = JSON.generate(data)
        Storage::Sync.connection.del(@key)
        Storage::Sync.connection.publish("scales_monitor_events", json)
      end
      
      def put_request_in_queue!(job)
        data  = {
          :id         => job['scales.id'],
          :server_id  => @id,
          :type       => "server_put_request_in_queue",
          :path       => job['PATH_INFO'],
          :method     => job['REQUEST_METHOD']
        }
        json = JSON.generate(data)
        Storage::Sync.connection.publish("scales_monitor_events", json)
      end
      
      def took_response_from_queue!(response)
        data  = {
          :id         => response[1]['scales.id'],
          :server_id  => @id,
          :type       => "server_took_response_from_queue",
          :path       => response[1]['PATH_INFO'],
          :method     => response[1]['REQUEST_METHOD'],
          :status     => response[0]
        }
        json = JSON.generate(data)
        Storage::Sync.connection.publish("scales_monitor_events", json)
      end
      
    end  
    
  end
end