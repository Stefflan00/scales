require 'helper'

describe Scales::Dispatch::Enqueue do
  
  it "should put a request to the queue" do
    with_api(Scales::Server::Server, :log_stdout => true) do
      
      # Simulate response after 2 seconds
      EventMachine::Timer.new(2) do
        id = Scales::Storage::Sync.get("test_last_request_id")
        Scales::PubSub::Sync.publish(id, JSON.generate([201,{},""]))
      end
      
      post_request(:path => '/new') do |client|
        client.response_header.http_status.should == 201
      end
      
    end
  end
  
end