require 'helper'

describe Scales::Server::Dispatch::Job do
  
  it "converts to a request" do
    Scales::Server::Dispatch::Job.to_request({}).should be_a(Hash)
  end
  
  it "converts response to a rack response" do
    Scales::Server::Dispatch::Job.to_response(JSON.generate([201, {}, ""])).should be_a(Array)
  end
  
end