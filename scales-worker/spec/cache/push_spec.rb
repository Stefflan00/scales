require 'helper'

describe Scales::Worker::Cache::Push do
  
  it "pushs a value to a key" do
    described_class.push :html => "A track", :to => "/tracks/15"
    Scales::Storage::Sync.get("/tracks/15").should == "A track"
  end
  
  it "raises an exception when the :to parameter is missing" do
    expect { described_class.push :html => "A track" }.to raise_error, "Don't know where to push, missing :to => '/a/path' parameter"
  end
  
  it "raises an exception when an unknown content type is set" do
    expect { described_class.push :unknown => "A track", :to => "/a/key" }.to raise_error, "Unknown content type :unknown"
  end
  
  it "sends an key event on pushing" do
    Thread.new do
      sleep 2
      described_class.push :html => "A track", :to => "/tracks/15"
    end
    
    @subscriber = Scales::Storage::Sync.new_connection!
    @subscriber.subscribe('scales_monitor_events') do |on|
      on.message do |channel, message|
        received_response = JSON.parse(message)
        
        received_response["path"].should   == "/tracks/15"
        received_response["format"].should == "HTML"
        received_response["type"].should   == "push_key"
        
        @subscriber.unsubscribe('scales_monitor_events')
      end
    end
  end
  
  it "sends an partial event on pushing" do
    Thread.new do
      sleep 2
      described_class.push :html => "A track", :to => "tracks/15/_navigation"
    end
    
    @subscriber = Scales::Storage::Sync.new_connection!
    @subscriber.subscribe('scales_monitor_events') do |on|
      on.message do |channel, message|
        received_response = JSON.parse(message)
        
        received_response["path"].should   == "tracks/15/_navigation"
        received_response["format"].should == "HTML"
        received_response["type"].should   == "push_partial"
        
        @subscriber.unsubscribe('scales_monitor_events')
      end
    end
  end
  
  context Scales do
    
    it "pushs a value to a key" do
      Scales.push :html => "A track", :to => "/tracks/15"
      Scales::Storage::Sync.get("/tracks/15").should == "A track"
    end
    
  end
  
end