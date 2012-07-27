require 'helper'

describe Scales do
  
  it "tries to set the env" do
    Scales.env = nil
    ARGV = ["test"]
    Scales.try_to_setup_env!
    Scales.env.should == "test"
  end
  
  it "ignores env with options" do
    Scales.env = nil
    ARGV = ["-o"]
    Scales.try_to_setup_env!
    Scales.env.should == "development"
  end
  
end