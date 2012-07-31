require 'helper'

describe Scales::Worker::Cache::Destroy do
  
  it "destroys a value at a path" do
    Scales::Storage::Sync.set "/tracks/15", "A track"
    described_class.destroy "/tracks/15"
    Scales::Storage::Sync.get("/tracks/15").should be_nil
  end
  
  it "sends a key event on destroying" do
    Thread.new do
      sleep 2
      described_class.destroy "/tracks/15"
    end
    
    @subscriber = Scales::Storage::Sync.new_connection!
    @subscriber.subscribe('scales_monitor_events') do |on|
      on.message do |channel, message|
        received_response = JSON.parse(message)
        
        received_response["path"].should   == "/tracks/15"
        received_response["type"].should   == "destroy_key"
        
        @subscriber.unsubscribe('scales_monitor_events')
      end
    end
  end
  
  it "sends a partial event on destroying" do
    Thread.new do
      sleep 2
      described_class.destroy "tracks/15/_navigation"
    end
    
    @subscriber = Scales::Storage::Sync.new_connection!
    @subscriber.subscribe('scales_monitor_events') do |on|
      on.message do |channel, message|
        received_response = JSON.parse(message)
        
        received_response["path"].should   == "tracks/15/_navigation"
        received_response["type"].should   == "destroy_partial"
        
        @subscriber.unsubscribe('scales_monitor_events')
      end
    end
  end
  
  context Scales do
    it "destroys a value at a path" do
      Scales::Storage::Sync.set "/tracks/15", "A track"
      Scales.destroy "/tracks/15"
      Scales::Storage::Sync.get("/tracks/15").should be_nil
    end
  end
  
end