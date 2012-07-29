require 'helper'

describe Scales::Monitor do
  it "should have a version" do
    Scales::Monitor::VERSION.should_not be_nil
  end
end