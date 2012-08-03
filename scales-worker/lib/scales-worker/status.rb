module Scales
  module Worker
    
    class Status
      attr_reader :key, :id, :address, :port, :logger, :log_path
      
      def initialize address, port = nil
        @id             = SecureRandom.hex(8)
        @key            = "scales_worker_#{@id}"
        @address, @port = address.to_s, port.to_s
        @log_path       = "log/scales_worker.#{@id}.log"
        @logger         = Logger.new(Scales.env == "test" ? STDOUT : @log_path)
        @redis          = Scales::Storage::Sync.new_connection!
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
        
        @redis.set(@key, json)
        @redis.publish("scales_monitor_events", json)
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
        @redis.del(@key)
        @redis.publish("scales_monitor_events", json)
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
        @redis.publish("scales_monitor_events", json)
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
        @redis.publish("scales_monitor_events", json)
      end
      
    end  
    
  end
end