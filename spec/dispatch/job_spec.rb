require 'helper'

describe Scales::Dispatch::Job do
  
  it "converts to a request" do
    Scales::Dispatch::Job.to_request({}).should be_a(Hash)
  end
  
  it "converts response to a rack response" do
    Scales::Dispatch::Job.to_response({}).should be_a(Array)
  end
  
end