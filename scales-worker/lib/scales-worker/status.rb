module Scales
  module Worker
    
    class Status
      attr_reader :key, :id, :address, :port
      
      def initialize address, port = nil
        @address, @port = address.to_s, port.to_s
      end
      
      def start!
        @id   = SecureRandom.hex(8)
        @key  = "scales_worker_#{@id}"
        data  = {
          :id         => @id,
          :key        => @key,
          :type       => "start",
          :spawned_at => Time.now.to_i,
          :env        => Scales.env,
          :ip         => @address,
          :port       => @port
        }
        json = JSON.generate(data)
        
        Storage::Sync.connection.set(@key, json)
        Storage::Sync.connection.publish("scales_monitor_events", json)
        @already_stopped = false
      end
      
      def stop!
        return if @already_stopped
        
        data  = {
          :id         => @id,
          :key        => @key,
          :type       => "stop"
        }
        json = JSON.generate(data)
        Storage::Sync.connection.del(@key)
        Storage::Sync.connection.publish("scales_monitor_events", json)
        @already_stopped = true
      end
      
    end  
    
  end
end