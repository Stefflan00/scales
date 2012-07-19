require 'helper'

describe Scales::Core do
  it "should have a version" do
    Scales::Core::VERSION.should_not be_nil
  end
end