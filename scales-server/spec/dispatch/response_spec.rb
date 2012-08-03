require 'helper'

describe Scales::Server::Dispatch::Response do
  
  before(:each) do
    described_class.reset!
  end
  
  it "receives a response via pubsub" do
    async do
      
      @id       = "893845bsd8f7t8ow37sf4"
      @response = [201,{ 'scales.id' => @id },"Some response text"]
      
      
      # Simulate response after 2 seconds
      EventMachine::Timer.new(2) do
        @worker = Scales::Storage::Sync.new_connection!
        @worker.publish(Scales::Storage::RESPONSE_CHANNEL, JSON.generate(@response))
      end
      
      described_class.subscribe(@id).should == @response
      
    end
  end
  
end