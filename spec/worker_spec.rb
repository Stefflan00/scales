require 'helper'

describe Scales::Worker do
  
  it "creates a new worker instance" do
    Scales::Worker.run!.should be_a(Scales::Worker::Worker)
  end
  
end