require 'helper'

describe Scales::Worker do
  it "should have a version" do
    Scales::Worker::VERSION.should_not be_nil
  end
end