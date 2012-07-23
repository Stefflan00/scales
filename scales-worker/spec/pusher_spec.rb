require 'helper'

describe Scales::Worker::Pusher do
  
  before(:all) do
    in_app_folder do
      @pusher = Scales::Worker::Pusher.new
    end
  end
  
  it "creates a new pusher instance" do
    @pusher.should be_a(Scales::Worker::Pusher)
  end
  
  it "app should respond to call" do
    @pusher.app.should respond_to(:call)
  end
  
  it "raises exception when no paths are added" do
    expect{ @pusher.push!([]) }.to raise_error, "No Paths added"
  end
  
  it "processes a push completely" do
    path  = { :to => "/tracks", :format => :html, :push => true }
    env   = @pusher.process!(path)
    
    env.should be_a(Hash)
    Scales::Storage::Sync.get("/tracks").should have_at_least(100).characters
  end
  
  it "processes a full push" do    
    path  = { :to => "/tracks", :format => :html, :push => true }
    @pusher.process_push!(path)
    
    Scales::Storage::Sync.get("/tracks").should have_at_least(100).characters
  end
  
  it "processes a full update" do    
    path  = { :to => "/tracks", :format => :html }
    @pusher.process_push!(path)
  end
  
  it "tracks progress" do
    paths = [
      { :to => "/tracks", :format => :html },
      { :to => "/tracks/1", :format => :html },
      { :to => "/tracks/2", :format => :html }
    ]
    
    @pusher.reset_progress!
    @pusher.total.should == 0
    @pusher.done.should == 0
    @pusher.progress.should == 0
    
    @pusher.push!(paths)
    
    @pusher.total.should == 3
    @pusher.done.should == 3
    @pusher.progress.should == 100
  end
  
  context "post processing" do
    
    it "should post process all paths" do
      path  = { :to => "/tracks", :format => :html }
      env   = @pusher.process!(path)
      
      in_process_thread do
        Scales.update "/tracks/1", "/tracks/1/edit"
        @pusher.post_process!(env)
        
        Thread.current[:post_process_queue].should be_empty
      end
    end
    
  end
  
end