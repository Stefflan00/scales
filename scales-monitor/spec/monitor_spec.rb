require 'helper'

describe Scales::Monitor::Monitor do
  
  it "serves paths from cache" do
    described_class.serve("/").should have_at_least(100).characters
  end
  
end

describe Scales::Monitor do
  
  before :all do
    @server_pid = fork do
      trap('INT') do
        exit 0
      end
      
      Scales::Storage::Sync.force_reconnect!
      
      ARGV << "-p" << "9000"
      Scales::Monitor.run!
    end
    
    puts "Waiting for monitor server to spawn ..."
    sleep 2
  end
  
  after :all do
    Process.kill("INT", @server_pid)
    Process.wait
  end
  
  it "should answer requests" do
    EventMachine.run {
      http = EventMachine::HttpRequest.new('http://127.0.0.1:9000/').aget

      http.errback {
        EventMachine.stop
        fail "Request did not work!"
      }
      http.callback {
        http.response_header.status.should == 200
        http.response.should have_at_least(100).characters
        EventMachine.stop
      }
    }
  end
  
end