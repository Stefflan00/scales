require 'helper'

describe Scales::Config do
  
  before(:each) do
    described_class.reset!
  end
  
  it "should have default values" do
    Scales.config.should_not be_nil
    Scales.config.host.should == "localhost"
    Scales.config.port.should == 6379
  end
  
  it "should be able to write new values" do
    Scales.config.test.should be_nil
    Scales.config.test = "a new values"
    Scales.config.test.should == "a new values"
  end
  
  context "loading cache.yml" do
    
    it "loads cache.yml if it exists" do
      in_app_folder do
        Scales.env = "production"
        Scales.config.host.should == "123.123.123.123"
        Scales.config.port.should == 6380
        Scales.config.password.should == "secret"
        Scales.config.database.should == 5
      end
    end
    
    it "sticks with the defaults if it doesn't" do
      Scales.env = "production"
      Scales.config.host.should == "localhost"
      Scales.config.port.should == 6379
      Scales.config.password.should be_nil
      Scales.config.database.should == 0
    end
    
  end
  
end