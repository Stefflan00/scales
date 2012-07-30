require 'helper'

describe Scales::Server::Status do
  
  it "adds and removes itself" do
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
  
  it "publishes an added request" do
    Thread.new do
      sleep 2
      
      @publisher = described_class.new("localhost", 3000)
      @job = {
        'scales.id'       => "7i36grk",
        'PATH_INFO'       => "/some/path",
        'REQUEST_METHOD'  => "POST"
      }
      
      @publisher.put_request_in_queue!(@job)
    end
    
    @subscriber = Scales::Storage::Sync.new_connection!
    @subscriber.subscribe('scales_monitor_events') do |on|
      on.message do |channel, message|
        received_job = JSON.parse(message)
        
        received_job["id"].should     == "7i36grk"
        received_job["method"].should == "POST"
        received_job["path"].should   == "/some/path"
        received_job["type"].should   == "server_put_request_in_queue"
        
        @subscriber.unsubscribe('scales_monitor_events')
      end
    end
  end
  
  it "publishes a taken response" do
    Thread.new do
      sleep 2
      
      @publisher = described_class.new("localhost", 3000)
      @response = [200, {
        'scales.id'       => "7i36grk",
        'REQUEST_METHOD'  => "POST",
        'PATH_INFO'       => "/some/path"
        }, ""]
      
      @publisher.took_response_from_queue!(@response)
    end
    
    @subscriber = Scales::Storage::Sync.new_connection!
    @subscriber.subscribe('scales_monitor_events') do |on|
      on.message do |channel, message|
        received_response = JSON.parse(message)
        
        received_response["id"].should     == "7i36grk"
        received_response["method"].should == "POST"
        received_response["path"].should   == "/some/path"
        received_response["type"].should   == "server_took_response_from_queue"
        received_response["status"].should == 200
        
        @subscriber.unsubscribe('scales_monitor_events')
      end
    end
  end
  
end