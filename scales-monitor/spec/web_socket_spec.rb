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
    
    it "sends requests" do
      with_api(described_class, {:verbose => true, :log_stdout => true}) do |server|
        json = "{\"scales.id\":\"4f57fcec795b6a6158796a1958e781f0\",\"SERVER_NAME\":\"0.0.0.0\",\"SERVER_PORT\":\"3005\",\"REQUEST_METHOD\":\"POST\",\"QUERY_STRING\":\"\",\"PATH_INFO\":\"/tracks\",\"HTTP_HOST\":\"0.0.0.0:3005\",\"HTTP_USER_AGENT\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/536.19 (KHTML, like Gecko) Version/6.0 Safari/536.19\",\"HTTP_ACCEPT\":\"text/html, application/xhtml+xml, application/xml;q=0.9, */*;q=0.8\",\"HTTP_ORIGIN\":\"http://0.0.0.0:3005\",\"HTTP_REFERER\":\"http://0.0.0.0:3005/tracks/new\",\"HTTP_ACCEPT_LANGUAGE\":\"en-us\",\"HTTP_ACCEPT_ENCODING\":\"gzip, deflate\",\"HTTP_CONNECTION\":\"keep-alive\",\"HTTP_VERSION\":\"1.1\",\"rack.version\":[1,0],\"rack.url_scheme\":null,\"rack.input\":\"utf8=%E2%9C%93&authenticity_token=gniWYAZpl67rSI0VYfrpoBXJ3Ipv9ZEv9VY9FSbyoDM%3D&track%5Bname%5D=Next+one&track%5Bartist%5D=Okay+here&commit=Create+Track\"}"
        Scales::Storage::Async.connection.lpush("scales_request_queue", json)
        Scales::Storage::Async.connection.lpush("scales_request_queue", json)

        requests = described_class.new.instance_eval{ request_queue }
        requests.should have_at_least(2).requests
        EM.stop
      end
    end
    
    it "sends responds" do
      with_api(described_class, {:verbose => true, :log_stdout => true}) do |server|
        json = "[302,{\"Location\":\"http://0.0.0.0:3005/tracks/170\",\"Content-Type\":\"text/html; charset=utf-8\",\"Set-Cookie\":\"_app_session=BAh7B0kiCmZsYXNoBjoGRUZvOiVBY3Rpb25EaXNwYXRjaDo6Rmxhc2g6OkZsYXNoSGFzaAk6CkB1c2VkbzoIU2V0BjoKQGhhc2h7ADoMQGNsb3NlZEY6DUBmbGFzaGVzewY6C25vdGljZUkiJFRyYWNrIHdhcyBzdWNjZXNzZnVsbHkgY3JlYXRlZC4GOwBGOglAbm93MEkiD3Nlc3Npb25faWQGOwBGSSIlZDkxNDA4OTFmMWVhZTJlNGU2MmM3MmRkOTA4NDZjODUGOwBU--fd4912d39bd51eedcd5bf0519a939e5b38317b34; path=/; HttpOnly\",\"scales.id\":\"155a255dd3604fa2e39469e30aef3206\"},\"<html><body>You are being <a href=\\\"http://0.0.0.0:3005/tracks/170\\\">redirected</a>.</body></html>\"]"
        Scales::Storage::Async.connection.lpush("scales_response_155a255dd3604fa2e39469e30aef3206", json)
        Scales::Storage::Async.connection.lpush("scales_response_155a255dd3604fa2e39469e30aef3207", json)

        responses = described_class.new.instance_eval{ response_queue }
        responses.should have_at_least(2).responses
        EM.stop
      end
    end
    
  end
  
  
  
end