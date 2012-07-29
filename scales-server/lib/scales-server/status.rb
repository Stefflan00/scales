module Scales
  module Server
    
    class Status
      attr_reader :key, :id, :address, :port
      
      def initialize address, port
        @address, @port = address.to_s, port.to_s
      end
      
      def start!
        @id   = SecureRandom.hex(8)
        @key  = "scales_server_#{@id}"
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
      
    end  
    
  end
end