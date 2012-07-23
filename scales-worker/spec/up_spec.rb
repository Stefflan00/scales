require 'helper'

describe Scales::Up do
  
  it "adds push paths" do
    in_app_folder do
      @scales = described_class.new :up do |scales|
        scales.push :html, :to => "/tracks/1"
        scales.push :html, :to => "/tracks/2"
      end
      Rake::Task['up'].invoke
      @scales.paths.should == [
        { :format => :html, :to => "/tracks/1", :push => true },
        { :format => :html, :to => "/tracks/2", :push => true }
      ]
    end
  end
  
  it "adds update paths" do
    in_app_folder do
      @scales = described_class.new :up2 do |scales|
        scales.update "/tracks/1", "/tracks/2", :format => :html
      end
      Rake::Task['up2'].invoke
      @scales.paths.should == [
        { :format => :html, :to => "/tracks/1" },
        { :format => :html, :to => "/tracks/2" }
      ]
    end
  end
  
  it "update throws an exception if no format is defined" do
    expect{ 
      @scales = described_class.new :up3 do |scales|
        scales.update "/tracks/1", "/tracks/2"
      end
      Rake::Task['up3'].invoke
    }.to raise_exception "Please define a format like this :format => :html"
  end
  
  it "update throws an exception if format is not found" do
    expect{ 
      @scales = described_class.new :up4 do |scales|
        scales.update "/tracks/1", "/tracks/2", :format => :unknown
      end
      Rake::Task['up4'].invoke
    }.to raise_exception "Unknown format :unknown"
  end
  
  it "creates a scale up task" do
    in_app_folder do
      task = described_class.new :up5 do |scales|
        Track.count
        scales.push :html, :to => "/tracks/1"
        scales.push :html, :to => "/tracks/2"
      end
      task.paths.should be_empty
      Rake::Task['up5'].invoke
      task.paths.should have(2).paths
      
      Scales::Storage::Sync.get("/tracks/1").should have_at_least(100).characters
      Scales::Storage::Sync.get("/tracks/2").should have_at_least(100).characters
    end
  end
  
end