require 'helper'

describe Scales::Worker::Cache::Update do
    
  it "adds paths to the threads post_process_jobs queue" do
    in_process_thread do
      described_class.update "/track", "/tracks/1/edit", "/navigation"
      Thread.current[:post_process_queue].should == ["/track", "/tracks/1/edit", "/navigation"]
    end
  end
  
  context Scales do
    it "adds update paths to the threads post_process_jobs queue" do
      in_process_thread do
        Scales.update "/track", "/tracks/1/edit", "/navigation"
        Thread.current[:post_process_queue].should == ["/track", "/tracks/1/edit", "/navigation"]
      end
    end
    
    it "adds refresh paths to the threads post_process_jobs queue" do
      in_process_thread do
        Scales.refresh "/track", "/tracks/1/edit", "/navigation"
        Thread.current[:post_process_queue].should == ["/track", "/tracks/1/edit", "/navigation"]
      end
    end
    
    it "adds reload paths to the threads post_process_jobs queue" do
      in_process_thread do
        Scales.reload "/track", "/tracks/1/edit", "/navigation"
        Thread.current[:post_process_queue].should == ["/track", "/tracks/1/edit", "/navigation"]
      end
    end
    
    it "adds repush paths to the threads post_process_jobs queue" do
      in_process_thread do
        Scales.repush "/track", "/tracks/1/edit", "/navigation"
        Thread.current[:post_process_queue].should == ["/track", "/tracks/1/edit", "/navigation"]
      end
    end
  end
  
end