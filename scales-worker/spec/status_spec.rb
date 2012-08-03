require 'helper'

describe Scales::Worker::Status do
  
  it "adds and removes itself" do
    in_process_thread do
      @publisher = described_class.new("localhost", 3000)
      @publisher.start!
      status = Scales::Storage::Sync.connection.get(@publisher.key)
    
      status.should be_a(String)
      status = JSON.parse(status)
      status.should be_a(Hash)
      status['id'].should == @publisher.id
    
      @publisher.stop!
    
      Scales::Storage::Sync.connection.get(@publisher.key).should be_nil
    end
  end
  
  it "publishes a taken request" do
    Thread.new do
      sleep 2
    
      @publisher = described_class.new("localhost", 3000)
      @job = {
        'scales.id'       => "7i36grk",
        'PATH_INFO'       => "/some/path",
        'REQUEST_METHOD'  => "POST"
      }
      
      in_process_thread do
        @publisher.took_request_from_queue!(@job)
      end
    end
  
    @subscriber = Scales::Storage::Sync.new_connection!
    @subscriber.subscribe('scales_monitor_events') do |on|
      on.message do |channel, message|
        received_request = JSON.parse(message)
      
        received_request["id"].should     == "7i36grk"
        received_request["method"].should == "POST"
        received_request["path"].should   == "/some/path"
        received_request["type"].should   == "worker_took_request_from_queue"
      
        @subscriber.unsubscribe('scales_monitor_events')
      end
    end
  end
  
  it "publishes an added response" do
    Thread.new do
      sleep 2
    
      @publisher = described_class.new("localhost", 3000)
      @response = [200, {
        'scales.id'       => "7i36grk",
        'REQUEST_METHOD'  => "POST",
        'PATH_INFO'       => "/some/path"
        }, ""]
      
      in_process_thread do
        @publisher.put_response_in_queue!(@response)
      end
    end
  
    @subscriber = Scales::Storage::Sync.new_connection!
    @subscriber.subscribe('scales_monitor_events') do |on|
      on.message do |channel, message|
        received_response = JSON.parse(message)
      
        received_response["id"].should     == "7i36grk"
        received_response["method"].should == "POST"
        received_response["path"].should   == "/some/path"
        received_response["type"].should   == "worker_put_response_in_queue"
        received_response["status"].should == 200
      
        @subscriber.unsubscribe('scales_monitor_events')
      end
    end
  end
  
end