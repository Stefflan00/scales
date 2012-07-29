require 'helper'

describe Scales::Worker::Status do
  
  it "adds and removes itself" do
    @publisher = described_class.new("localhost", 3000)
    @publisher.start!
    status = Scales::Storage::Sync.connection.get(@publisher.key)
    
    status.should be_a(String)
    status = JSON.parse(status)
    status.should be_a(Hash)
    status['id'].should == @publisher.id
    
    @publisher.stop!
    
    Scales::Storage::Sync.connection.get(@publisher.key).should be_nil
  end
  
end