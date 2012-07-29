require 'helper'

describe Scales::Monitor::Monitor do
  
  before(:all) do
    @monitor = described_class.new
  end
  
  after(:all) do
    @monitor.stop!
  end
  
  it "loads the index page" do
    response = get "http://127.0.0.1:3000/"
    
    response.code.to_i.should == 200
    response.body.should have_at_least(100).characters
    response["Content-Type"].should == "text/html"
  end
  
end