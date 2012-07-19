require 'helper'

describe Scales::Dispatch::Request do
  
  it "converts to a job" do
    Scales::Dispatch::Request.to_job("id", {}).should be_a(Hash)
  end
  
end