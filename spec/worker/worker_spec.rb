require 'run_application'
require 'helper'

describe Scales::Worker::Worker do
  
  it "should load an app on creation" do
    in_app_folder do
      worker = described_class.new
      worker.app.should respond_to(:call)
    end
  end
  
end