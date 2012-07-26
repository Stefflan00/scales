require 'helper'

describe Scales::Worker::Cache::JSON do
  
  before(:each) do
    @json = <<-JSON
    { 
      "tracks" : [
        {
          "id" : 1,
          "name" : "Islandary"
        }
      ]
    }
    JSON
  end
  
  it "raises exception on missing path" do
    expect{ described_class.append :json => '{ "id" : 2, "name" : "Wait for it" }' }.to raise_error 'No path defined like this :to => "/tracks.json"'
  end
  
  it "raises exception on missing selector" do
    expect{ described_class.append :json => '{ "id" : 2, "name" : "Wait for it" }', :to => "/something" }.to raise_error 'No selector defined like this :select => "#tracks"'
  end
  
  it "appends an object" do
    Scales::Storage::Sync.set "/tracks.json", @json
    described_class.append :json => '{ "id" : 2, "name" : "Wait for it" }', :to => "/tracks.json", :select => "$.tracks"
    squeeze_json(Scales::Storage::Sync.get("/tracks.json")).should == squeeze_json(<<-JSON
    { 
      "tracks" : [
        {
          "id" : 1,
          "name" : "Islandary"
        },
        {
          "id" : 2,
          "name" : "Wait for it"
        }
      ]
    }
    JSON
    )
  end
  
  it "prepends an object" do
    Scales::Storage::Sync.set "/tracks.json", @json
    described_class.prepend :json => '{ "id" : 2, "name" : "Wait for it" }', :to => "/tracks.json", :select => "$.tracks"
    squeeze_json(Scales::Storage::Sync.get("/tracks.json")).should == squeeze_json(<<-JSON
    { 
      "tracks" : [
        {
          "id" : 2,
          "name" : "Wait for it"
        },
        {
          "id" : 1,
          "name" : "Islandary"
        }
      ]
    }
    JSON
    )
  end
  
  it "sets an object" do
    Scales::Storage::Sync.set "/tracks.json", @json
    described_class.set :json => '{ "id" : 2, "name" : "Wait for it" }', :to => "/tracks.json", :select => "$.tracks"
    squeeze_json(Scales::Storage::Sync.get("/tracks.json")).should == squeeze_json(<<-JSON
    { 
      "tracks" : {
        "id" : 2,
        "name" : "Wait for it"
      }
    }
    JSON
    )
  end
  
  it "replaces an object" do
    Scales::Storage::Sync.set "/tracks.json", @json
    described_class.replace :json => '{ "id" : 2, "name" : "Wait for it" }', :to => "/tracks.json", :select => "$.tracks"
    squeeze_json(Scales::Storage::Sync.get("/tracks.json")).should == squeeze_json(<<-JSON
    { 
      "tracks" : {
        "id" : 2,
        "name" : "Wait for it"
      }
    }
    JSON
    )
  end
  
  it "removes an object" do
    Scales::Storage::Sync.set "/tracks.json", @json
    described_class.remove :at => "/tracks.json", :select => "$.tracks"
    squeeze_json(Scales::Storage::Sync.get("/tracks.json")).should == squeeze_json(<<-JSON
    {
      
    }
    JSON
    )
  end
  
  context Scales do
    
    it "appends an object" do
      Scales::Storage::Sync.set "/tracks.json", @json
      Scales.append :json => '{ "id" : 2, "name" : "Wait for it" }', :to => "/tracks.json", :select => "$.tracks"
      squeeze_json(Scales::Storage::Sync.get("/tracks.json")).should == squeeze_json(<<-JSON
      { 
        "tracks" : [
          {
            "id" : 1,
            "name" : "Islandary"
          },
          {
            "id" : 2,
            "name" : "Wait for it"
          }
        ]
      }
      JSON
      )
    end

    it "prepends an object" do
      Scales::Storage::Sync.set "/tracks.json", @json
      Scales.prepend :json => '{ "id" : 2, "name" : "Wait for it" }', :to => "/tracks.json", :select => "$.tracks"
      squeeze_json(Scales::Storage::Sync.get("/tracks.json")).should == squeeze_json(<<-JSON
      { 
        "tracks" : [
          {
            "id" : 2,
            "name" : "Wait for it"
          },
          {
            "id" : 1,
            "name" : "Islandary"
          }
        ]
      }
      JSON
      )
    end

    it "sets an object" do
      Scales::Storage::Sync.set "/tracks.json", @json
      Scales.set :json => '{ "id" : 2, "name" : "Wait for it" }', :to => "/tracks.json", :select => "$.tracks"
      squeeze_json(Scales::Storage::Sync.get("/tracks.json")).should == squeeze_json(<<-JSON
      { 
        "tracks" : {
          "id" : 2,
          "name" : "Wait for it"
        }
      }
      JSON
      )
    end

    it "replaces an object" do
      Scales::Storage::Sync.set "/tracks.json", @json
      Scales.replace :json => '{ "id" : 2, "name" : "Wait for it" }', :to => "/tracks.json", :select => "$.tracks"
      squeeze_json(Scales::Storage::Sync.get("/tracks.json")).should == squeeze_json(<<-JSON
      { 
        "tracks" : {
          "id" : 2,
          "name" : "Wait for it"
        }
      }
      JSON
      )
    end

    it "removes an object" do
      Scales::Storage::Sync.set "/tracks.json", @json
      Scales.remove :json, :at => "/tracks.json", :select => "$.tracks"
      squeeze_json(Scales::Storage::Sync.get("/tracks.json")).should == squeeze_json(<<-JSON
      {

      }
      JSON
      )
    end
    
  end
  
end