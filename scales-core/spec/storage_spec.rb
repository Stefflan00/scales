require 'helper'

describe Scales::Storage::Sync do
  
  it "should set and get a key" do
    Scales::Storage::Sync.set "test_key", "a test value"
    Scales::Storage::Sync.get("test_key").should == "a test value"
  end
  
end

describe Scales::Storage::Async do
  
  it "should set and get a key" do
    async do
      Scales::Storage::Async.set("test_key", "a test value") do
        Scales::Storage::Async.get("test_key") do |value|
          value.should == "a test value"
        end
      end
    end
  end
  
end