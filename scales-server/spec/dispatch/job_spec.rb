require 'helper'

describe Scales::Server::Dispatch::Job do
  
  it "converts response to a rack response" do
    Scales::Server::Dispatch::Job.to_response(JSON.generate([201, {}, ""])).should be_a(Array)
  end
  
end