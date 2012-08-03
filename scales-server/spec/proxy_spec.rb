require 'helper'

describe Scales::Server::Proxy do
  
  before :all do
    spawn_server(3010)
    spawn_server(3011)
    spawn_proxy(4000, [3010, 3011])
  end
  
  after :all do
    kill_spawned_servers
  end
  
  it "should answer requests" do    
    Scales::Storage::Sync.set_content "/", "Hey there!"
    
    EventMachine.run {
      http = EventMachine::HttpRequest.new('http://127.0.0.1:4000/').aget

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
    
    Scales::Storage::Sync.del_content "/"
  end
  
end