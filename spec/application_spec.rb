require 'helper_application'

describe ScalesApplication do
  
  it "should start and stop" do
    in_app_folder do
      described_class.run!
      described_class.stop!
    end
  end
  
  it "should respond to call" do
    in_app_folder do
      described_class.run!
      
      DRb.start_service
      DRbObject.new_with_uri(described_class::URI).should respond_to(:call)
      
      described_class.stop!
    end
  end
  
end