require 'helper'

describe Scales::Server::Dispatch::Enqueue do
  
  before(:each) do
    Scales::Server::Dispatch::Response.reset!
  end
  
  it "should put a request to the queue" do
    in_app_folder do
      Scales::Server.status = Scales::Server::Status.new("localhost", "3000")
      with_api(Scales::Server::Server, :log_stdout => true) do
      
        # Simulate response after 2 seconds
        EventMachine::Timer.new(2) do
          id = Scales::Storage::Sync.get("test_last_request_id")
          Scales::Storage::Sync.connection.publish("scales_response_channel", JSON.generate([201,{ 'scales.id' => id },""]))
        end
      
        post_request(:path => '/new') do |client|
          client.response_header.http_status.should == 201
        end
      
      end
    end
  end
  
end