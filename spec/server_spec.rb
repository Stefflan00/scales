require 'helper'

describe Scales::Server do
  
  it "should receive requests" do
    Scales::Storage::Sync.set "/", "Root Content"
    
    with_api(Scales::Server) do
      get_request(:path => '/') do |client|
        client.response_header.status.should == 200
        client.response.should == "Root Content"
      end
    end
    
    Scales::Storage::Sync.del "/"
  end
  
end