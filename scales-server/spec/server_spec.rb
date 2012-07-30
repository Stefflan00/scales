require 'helper'

describe Scales::Server do
  
  before :all do
    @server_pid = fork do
      trap('INT') do
        exit 0
      end
      
      Scales::Storage::Sync.force_reconnect!
      
      ARGV << "-p" << "3004"
      Scales::Server.run!
    end
    
    puts "Waiting for server to spawn ..."
    sleep 2
  end
  
  after :all do
    Process.kill("INT", @server_pid)
    Process.wait
  end
  
  it "has a status object" do
    described_class.status.is_a?(Scales::Server::Status)
  end
  
  it "should answer requests" do    
    Scales::Storage::Sync.set "/", "Hey there!"
    
    EventMachine.run {
      http = EventMachine::HttpRequest.new('http://127.0.0.1:3004/').aget

      http.errback {
        EventMachine.stop
        fail "Request did not work!"
      }
      http.callback {
        http.response_header.status.should == 200
        http.response.should == "Hey there!"
        EventMachine.stop
      }
    }
    
    Scales::Storage::Sync.del "/"
  end
  
end