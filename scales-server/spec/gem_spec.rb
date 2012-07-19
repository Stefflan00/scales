require 'helper'

describe Scales::Server do
  it "should have a version" do
    Scales::Server::VERSION.should_not be_nil
  end
end