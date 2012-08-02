require 'helper'

describe Scales::Worker::Worker do
  
  before(:all) do
    in_app_folder do
      @worker = Scales::Worker::Worker.new
    end
  end
  
  it "creates a new worker instance" do
    @worker.should be_a(Scales::Worker::Worker)
  end
  
  it "app should respond to call" do
    @worker.app.should respond_to(:call)
    @worker.type.name.should == "Rails App (test)"
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
    Thread.current[:post_process_queue] = []
    job           = fixture "create_track_request.json"
    id, response  = @worker.process!(job)
    
    response.should be_a(Array)
    response.should have(3).entries
    response[0].should == 302
    response[1].should be_a(Hash)
    response[1]['scales.id'].should == "2c43b4fa508b923ad563b5395e1f4619"
    response[2].should be_a(String)
  end
  
  it "should not crash on a process error" do
    Thread.current[:post_process_queue] = []
    job           = fixture "no_route_request.json"
    id, response  = @worker.process!(job)
    
    response.should be_a(Array)
    response.should have(3).entries
    response[0].should == 404
    response[1].should be_a(Hash)
    response[1]['scales.id'].should == "2c43b4fa508b923ad563b5395e1f4619"
    response[2].should be_a(String)
  end
  
  it "process a whole iteration with the queue", :iteration do
    job = fixture "create_track_request.json"
    Scales::Queue::Sync.add(job)
    
    Thread.new do
      sleep 2
      Scales::Storage::Sync.new_connection!.subscribe('scales_response_channel') do |on|
        on.message do |channel, message|
          puts "Waiting for response"
          response = JSON.parse(message)
          response.should be_a(Array)
          response.should have(3).entries
        end
      end
      
    end
    
    @worker.process_request!
  end
  
  context "post processing" do
    
    it "should post process all jobs" do
      job = fixture "no_route_request.json"
      
      in_process_thread do
        Scales.update "/tracks", "/tracks/1/edit", :format => :html
        @worker.post_process!(job)
        
        Thread.current[:post_process_queue].should be_empty
      end
    end
    
  end
  
end