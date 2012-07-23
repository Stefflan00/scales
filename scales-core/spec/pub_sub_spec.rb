require 'helper'

describe Scales::PubSub::Async do
  
  it "should publish a few responses" do
    async do
      Scales::PubSub::Async.publish "channel1", "response 1"
      Scales::PubSub::Async.publish "channel2", "response 2"
      Scales::PubSub::Async.publish "channel3", "response 3"
    end
  end
  
  it "should subscribe to a few channels" do
    async do
      Scales::PubSub::Async.subscribe("channel1").should == "response 1"
      Scales::PubSub::Async.subscribe("channel2").should == "response 2"
      Scales::PubSub::Async.subscribe("channel3").should == "response 3"
    end
  end
  
end

describe Scales::PubSub::Sync do
  
  it "should publish a few responses" do
    Scales::PubSub::Sync.publish "channel1", "response 1"
    Scales::PubSub::Sync.publish "channel2", "response 2"
    Scales::PubSub::Sync.publish "channel3", "response 3"
  end
  
  it "should subscribe to a few channels" do
    Scales::PubSub::Sync.subscribe("channel1").should == "response 1"
    Scales::PubSub::Sync.subscribe("channel2").should == "response 2"
    Scales::PubSub::Sync.subscribe("channel3").should == "response 3"
  end
  
end

describe Scales::PubSub do
  
  it "subscribes async and pushes sync" do
    Thread.new do
      sleep 2
      Scales::PubSub::Sync.publish "channel1", "response 1"
    end
    async do
      Scales::PubSub::Async.subscribe("channel1").should == "response 1"
    end
  end
  
end