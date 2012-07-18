require 'helper'

describe Scales::Application do
  
  before :all do
    @server_pid = fork do
      trap('INT') do
        exit 0
      end
      
      ARGV << "-p" << "3000"
      Scales::Application.run!
    end
  end
  
  after :all do
    Process.kill("INT", @server_pid)
    Process.wait
  end
  
  it "should answer requests" do    
    Scales::Storage::Sync.set "/", "Hey there!"
    
    EventMachine.run {
      http = EventMachine::HttpRequest.new('http://127.0.0.1:3000/').aget

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