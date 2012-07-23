require 'helper'

describe Scales::Worker::Cache::Update do
    
  it "adds html paths to the threads post_process_jobs queue" do
    in_process_thread do
      described_class.update "/track", "/tracks/1/edit", "/navigation", :format => :html
      Thread.current[:post_process_queue].should == [
        { :format => :html, :to => "/track" }, 
        { :format => :html, :to => "/tracks/1/edit" }, 
        { :format => :html, :to => "/navigation" }
      ]
    end
  end
  
  it "throws an exception if no format is defined" do
    expect{ described_class.update "/track", "/tracks/1/edit", "/navigation" }.to raise_exception "Please define a format like this :format => :html"
  end
  
  it "throws an exception if format is not found" do
    expect{ described_class.update "/track", "/tracks/1/edit", "/navigation", :format => :unknown }.to raise_exception "Unknown format :unknown"
  end
  
  it "adds json paths to the threads post_process_jobs queue" do
    in_process_thread do
      described_class.update "/track", "/tracks/1/edit", "/navigation", :format => :json
      Thread.current[:post_process_queue].should == [
        { :format => :json, :to => "/track" }, 
        { :format => :json, :to => "/tracks/1/edit" }, 
        { :format => :json, :to => "/navigation" }
      ]
    end
  end
  
  context Scales do
    it "adds update paths to the threads post_process_jobs queue" do
      in_process_thread do
        Scales.update "/track", "/tracks/1/edit", "/navigation", :format => :html
        Thread.current[:post_process_queue].should == [
          { :format => :html, :to => "/track" }, 
          { :format => :html, :to => "/tracks/1/edit" }, 
          { :format => :html, :to => "/navigation" }
        ]
      end
    end
  end
  
end