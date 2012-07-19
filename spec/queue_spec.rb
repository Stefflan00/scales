require 'helper'

describe Scales::Queue::Sync do
  
  it "should place a few jobs" do
    Scales::Queue::Sync.add "job 1"
    Scales::Queue::Sync.add "job 2"
    Scales::Queue::Sync.add "job 3"
  end

  it "should take them out blocking" do
    Scales::Queue::Sync.pop.should == "job 1"
    Scales::Queue::Sync.pop.should == "job 2"
    Scales::Queue::Sync.pop.should == "job 3"
  end
  
end

describe Scales::Queue::Async do
  
  it "should place a few jobs" do
    async do
      Scales::Queue::Async.add "job 1"
      Scales::Queue::Async.add "job 2"
      Scales::Queue::Async.add "job 3"
    end
  end

  it "should take them out blocking" do
    async do
      Scales::Queue::Async.pop.should == "job 1"
      Scales::Queue::Async.pop.should == "job 2"
      Scales::Queue::Async.pop.should == "job 3"
    end
  end
  
end