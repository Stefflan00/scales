require 'helper'

class TestServer < Goliath::API
  use Goliath::Rack::Params
  use Goliath::Rack::DefaultMimeType
  use Scales::Server::ContentType, 'html'
  
  def response(env)
    [200,{},""]
  end
end

describe Scales::Server::ContentType do
  
  Scales::Server::ContentType::TYPES.each do |format, type|
    it "#{format} should be recognized" do
      with_api(TestServer, :log_stdout => true) do
        get_request(:path => "/test.#{format}") do |client|
          client.response_header['CONTENT_TYPE'].should =~ %r{^#{Regexp.escape(type)}}
        end
      end
    end
  end
  
  it "should set default empty content type to default value" do
    with_api(TestServer, :log_stdout => true) do
      get_request(:path => '/test') do |client|
        client.response_header['CONTENT_TYPE'].should =~ %r{^text/html}
      end
    end
  end
  
end