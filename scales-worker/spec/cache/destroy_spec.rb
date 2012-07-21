require 'helper'

describe Scales::Worker::Cache::Destroy do
  
  it "destroys a value at a path" do
    Scales::Storage::Sync.set "/tracks/15", "A track"
    described_class.destroy "/tracks/15"
    Scales::Storage::Sync.get("/tracks/15").should be_nil
  end
  
  context Scales do
    it "destroys a value at a path" do
      Scales::Storage::Sync.set "/tracks/15", "A track"
      Scales.destroy "/tracks/15"
      Scales::Storage::Sync.get("/tracks/15").should be_nil
    end
    
    it "deletes a value at a path" do
      Scales::Storage::Sync.set "/tracks/15", "A track"
      Scales.delete "/tracks/15"
      Scales::Storage::Sync.get("/tracks/15").should be_nil
    end

    it "removes a value at a path" do
      Scales::Storage::Sync.set "/tracks/15", "A track"
      Scales.remove "/tracks/15"
      Scales::Storage::Sync.get("/tracks/15").should be_nil
    end

    it "wipes a value at a path" do
      Scales::Storage::Sync.set "/tracks/15", "A track"
      Scales.wipe "/tracks/15"
      Scales::Storage::Sync.get("/tracks/15").should be_nil
    end
  end
  
end