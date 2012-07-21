require 'helper'

describe Scales::Worker::Path do
  
  it "create a env from a path" do
    env = eval(fixture "create_track_request.rb")
    described_class.to_env("/tracks", env).should be_a(Hash)
  end
  
end