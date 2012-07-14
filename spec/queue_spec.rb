require 'helper'

describe Scales::Queue::Sync do
  
  [Scales::Queue::Sync::Request, Scales::Queue::Sync::Response].each do |queue|
    context queue.name.split("::").last do

      it "should place a few jobs" do
        queue.add "job 1"
        queue.add "job 2"
        queue.add "job 3"
      end

      it "should take them out blocking" do
        queue.pop.should == "job 1"
        queue.pop.should == "job 2"
        queue.pop.should == "job 3"
      end

    end
  end
  
end

describe Scales::Queue::Async do
  
  [Scales::Queue::Async::Request, Scales::Queue::Async::Response].each do |queue|
    context queue.name.split("::").last do

      it "should place a few jobs" do
        async do
          queue.add "job 1"
          queue.add "job 2"
          queue.add "job 3"
        end
      end

      it "should take them out blocking" do
        async do
          queue.pop.should == "job 1"
          queue.pop.should == "job 2"
          queue.pop.should == "job 3"
        end
      end

    end
  end
  
end