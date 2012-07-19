require 'helper'

describe Scales::Server::Dispatch::Request do
  
  it "converts to a job" do
    env = eval fixture('env_post_request.rb')
    Scales::Server::Dispatch::Request.to_job("id", env).should be_a(Hash)
  end
  
end