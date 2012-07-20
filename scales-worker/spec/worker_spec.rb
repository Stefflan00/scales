require 'helper'

describe Scales::Worker::Worker do
  
  before(:all) do
    in_app_folder do
      @worker = Scales::Worker.run!
    end
  end
  
  it "creates a new worker instance" do
    @worker.should be_a(Scales::Worker::Worker)
  end
  
  it "app should respond to call" do
    @worker.app.should respond_to(:call)
  end
  
  it "parses a job to a env" do
    job     = fixture "create_track_request.json"
    request = eval(fixture "create_track_request.rb")
    env     = @worker.parse(job)
    
    request['rack.input'].should be_a(StringIO)
    request['rack.input'] = request['rack.input'].string
    
    env['rack.input'].should be_a(StringIO)
    env['rack.input'] = env['rack.input'].string
    
    env.should == request
  end
  
  it "processes a job completely" do
    job           = fixture "create_track_request.json"
    id, response  = @worker.process!(job)
    
    response.should be_a(Array)
    response.should have(3).entries
    response[0].should == 302
    response[1].should be_a(Hash)
    response[1]['scales.id'].should == "2c43b4fa508b923ad563b5395e1f4619"
    response[2].should be_a(String)
  end
  
  it "should work one iteration: take job out of queue, process, but answer back" do
    job = fixture "create_track_request.json"
    Scales::Queue::Sync.add(job)
    
    id, response = @worker.process_request!
    
    job = Scales::PubSub::Sync.subscribe(id)
    JSON.parse(job).should == response
  end
  
end