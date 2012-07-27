require 'helper'

describe Scales::Worker::Cache do
end

describe Scales do
  
  it "sync get" do
    @tracks = "Some tracks"
    Scales::Storage::Sync.set "/tracks", @tracks
    
    Scales.get("/tracks").should == @tracks
  end
  
end