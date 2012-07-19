require 'helper'

describe Scales::Config do
  
  it "should have default values" do
    Scales.config.should_not be_nil
    Scales.config.redis_host.should == "localhost"
    Scales.config.redis_port.should == 6379
  end
  
  it "should be able to write new values" do
    Scales.config.test.should be_nil
    Scales.config.test = "a new values"
    Scales.config.test.should == "a new values"
  end
  
end