require 'helper'

describe Scales::Up do
  
  it "creates a scale up task" do
    in_app_folder do
      task = described_class.new do |scales|
        Track.count
        scales.push :html, :to => "/tracks/1"
        scales.push :html, :to => "/tracks/2"
      end
      task.paths.should be_empty
      Rake::Task['up'].invoke
      task.paths.should have(2).paths
      
      Scales::Storage::Sync.get("/tracks/1").should have_at_least(100).characters
      Scales::Storage::Sync.get("/tracks/2").should have_at_least(100).characters
    end
  end
  
end