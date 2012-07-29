require 'helper'

describe Scales::Monitor::WebSocket do
  
  context "static files" do
    
    it "serves cached html files" do
      with_api(described_class, {:verbose => true, :log_stdout => true}) do |server|
        get_request(:path => "/") do |client|
          client.response_header['CONTENT_TYPE'].should =~ %r{^text/html}
        end
      end
    end
    
    it "serves cached json files" do
      with_api(described_class, {:verbose => true, :log_stdout => true}) do |server|
        get_request(:path => "/assets/application.js") do |client|
          client.response_header['CONTENT_TYPE'].should =~ %r{^application/javascript}
        end
      end
    end
    
  end
  
  context "initial statuses" do
    
    it "sends servers" do
      with_api(described_class, {:verbose => true, :log_stdout => true}) do |server|
        Scales::Storage::Async.connection.set("scales_server_725634", "server1")
        Scales::Storage::Async.connection.set("scales_server_8768fk", "server2")

        servers = described_class.new.instance_eval{ server_statuses }
        servers.include?("server1").should be_true
        servers.include?("server2").should be_true
        EM.stop
      end
    end
    
    it "sends workers" do
      with_api(described_class, {:verbose => true, :log_stdout => true}) do |server|
        Scales::Storage::Async.connection.set("scales_worker_725634", "worker1")
        Scales::Storage::Async.connection.set("scales_worker_8768fk", "worker2")

        workers = described_class.new.instance_eval{ worker_statuses }
        workers.include?("worker1").should be_true
        workers.include?("worker2").should be_true
        EM.stop
      end
    end
    
  end
  
  
  
end