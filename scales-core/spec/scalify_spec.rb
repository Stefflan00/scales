require 'helper'

describe Scales::Scalify do
  
  it "creates scaleup and cache.yml file" do
    in_temp_folder do
      described_class.start
      File.exists?("config/scaleup.rb").should be_true
      File.exists?("config/cache.yml").should be_true
    end
  end
  
end