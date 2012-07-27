require 'helper'

describe Scales do
  
  before(:all) do
    launch_worker!
    launch_server!
  end
  
  after(:all) do
    kill_worker!
    kill_server!
  end
  
  it "runs scaleup" do
    in_app_folder do
      system "scale up test"
    end
  end
  
  it "loads /tracks" do
    response = get "http://127.0.0.1:9000/tracks"
    
    response.code.to_i.should == 200
    response.body.should have_at_least(100).characters
    response["Content-Type"].should == "text/html"
  end
  
  it "loads /tracks.json" do
    response = get "http://127.0.0.1:9000/tracks.json"
    
    response.code.to_i.should == 200
    JSON.parse(response.body).should be_a(Array)
    response["Content-Type"].should == "application/json"
  end
  
  it "creates a new track" do
    response = post "http://127.0.0.1:9000/tracks", {"name" => "Islandary", "artist" => "Thomas Fankhauser" }
    response.code.to_i.should == 302
    response["Location"].should =~ /http\:\/\/127.0.0.1\:9000\/tracks\/[0-9]+/
    
    location = response["Location"]
    response = get(location)
    response.code.to_i.should == 200
    
    response = get("#{location}.json")
    response.code.to_i.should == 200
  end
  
end