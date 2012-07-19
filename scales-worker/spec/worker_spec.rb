require 'helper'

describe Scales::Worker::Worker do
  
  it "creates a new worker instance" do
    in_app_folder do
      Scales::Worker.run!.should be_a(Scales::Worker::Worker)
    end
  end
  
  it "should respond to call" do
    in_app_folder do
      worker = Scales::Worker.run!
      worker.app.should respond_to(:call)
    end
  end
  
end