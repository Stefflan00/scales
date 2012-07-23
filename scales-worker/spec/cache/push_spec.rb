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
  
  context Scales do
    
    it "pushs a value to a key" do
      Scales.push :html => "A track", :to => "/tracks/15"
      Scales::Storage::Sync.get("/tracks/15").should == "A track"
    end
    
  end
  
end