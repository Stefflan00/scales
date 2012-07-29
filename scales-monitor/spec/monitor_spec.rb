require 'helper'

describe Scales::Monitor::Monitor do
  
  it "serves paths from cache" do
    described_class.serve("/").should have_at_least(100).characters
  end
  
end