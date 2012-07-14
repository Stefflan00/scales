require 'helper'

describe Scales::Dispatch do

  it "should return a 404 if resource was not found" do
    with_api(Scales::Server) do
      
      Scales::Storage::Async.del "/"
      
      get_request(:path => '/') do |client|
        client.response_header.http_status.should == 404
      end
    end
  end

  it "should return an existing resource" do
    with_api(Scales::Server) do
      Scales::Storage::Async.set "/existing", "some content"
      
      get_request(:path => '/existing') do |client|
        client.response_header.http_status.should == 200
        client.response.should == "some content"
      end
      
      Scales::Storage::Async.del "/existing"
    end
  end

end