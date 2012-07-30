module Scales
  module Worker
    
    class Status
      attr_reader :key, :id, :address, :port
      
      def initialize address, port = nil
        @id   = SecureRandom.hex(8)
        @key  = "scales_worker_#{@id}"
        @address, @port = address.to_s, port.to_s
      end
      
      def start!
        data  = {
          :id         => @id,
          :key        => @key,
          :type       => "worker_started",
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
          :type       => "worker_stopped"
        }
        json = JSON.generate(data)
        Storage::Sync.connection.del(@key)
        Storage::Sync.connection.publish("scales_monitor_events", json)
        @already_stopped = true
      end
      
      def took_request_from_queue!(job)
        data  = {
          :id         => job['scales.id'],
          :worker_id  => @id,
          :type       => "worker_took_request_from_queue",
          :path       => job['PATH_INFO'],
          :method     => job['REQUEST_METHOD']
        }
        json = JSON.generate(data)
        Storage::Sync.connection.publish("scales_monitor_events", json)
      end
      
      def put_response_in_queue!(response)
        data  = {
          :id         => response[1]['scales.id'],
          :worker_id  => @id,
          :type       => "worker_put_response_in_queue",
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