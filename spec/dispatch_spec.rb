require 'helper'

describe Scales::Dispatch do
  
  context "idempotent requests" do
  
    it "should return a 404 if resource was not found" do
      with_api(Scales::Server::Server) do
      
        Scales::Storage::Async.del "/"
      
        get_request(:path => '/') do |client|
          client.response_header.http_status.should == 404
        end
      end
    end

    it "should return an existing resource" do
      with_api(Scales::Server::Server) do
        Scales::Storage::Async.set "/existing", "some content"
      
        get_request(:path => '/existing') do |client|
          client.response_header.http_status.should == 200
          client.response.should == "some content"
        end
      
        Scales::Storage::Async.del "/existing"
      end
    end
  
    context "content types" do
    
      Scales::Server::ContentType::TYPES.each do |format, type|
        it "#{format} should be recognized" do
          with_api(Scales::Server::Server, :log_stdout => true) do
            Scales::Storage::Async.set "/test.#{format}", "some content"
          
            get_request(:path => "/test.#{format}") do |client|
              client.response_header['CONTENT_TYPE'].should =~ %r{^#{Regexp.escape(type)}}
            end
          
            Scales::Storage::Async.del "/test.#{format}"
          end
        end
      end
    
      it "should be http if no format is given" do
        with_api(Scales::Server::Server) do
          Scales::Storage::Async.set "/existing", "some content"
        
          get_request(:path => '/existing') do |client|
            puts client.response_header['CONTENT_TYPE']
            client.response_header['CONTENT_TYPE'].should =~ %r{^text/html}
          end

          Scales::Storage::Async.del "/existing"
        end
      end
    
    end
  
  end
  
  context "changing requests" do
    
    
    
  end

end