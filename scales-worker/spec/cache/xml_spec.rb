require 'helper'

describe Scales::Worker::Cache::XML do
  
  before(:each) do
    @xml = <<-XML
    <tracks>
      <track>Track 1</track>
    </tracks>
    XML
  end
  
  it "raises exception on missing path" do
    expect{ described_class.append :xml => '<track>Track 2</track>' }.to raise_error 'No path defined like this :to => "/tracks.xml"'
  end
  
  it "raises exception on missing selector" do
    expect{ described_class.append :xml => '<track>Track 2</track>', :to => "/something" }.to raise_error 'No selector defined like this :select => "/tracks"'
  end
  
  it "appends a node" do
    Scales::Storage::Sync.set_content "/tracks.xml", @xml
    described_class.append :xml => '<track>Track 2</track>', :to => "/tracks.xml", :select => "/tracks"
    squeeze(Scales::Storage::Sync.get_content("/tracks.xml")).should == squeeze(<<-XML
      <tracks>
        <track>Track 1</track>
        <track>Track 2</track>
      </tracks>
    XML
    )
  end
  
  it "prepends a node" do
    Scales::Storage::Sync.set_content "/tracks.xml", @xml
    described_class.prepend :xml => '<track>Track 2</track>', :to => "/tracks.xml", :select => "/tracks"
    squeeze(Scales::Storage::Sync.get_content("/tracks.xml")).should == squeeze(<<-XML
      <tracks>
        <track>Track 2</track>
        <track>Track 1</track>
      </tracks>
    XML
    )
  end
  
  it "sets a node" do
    Scales::Storage::Sync.set_content "/tracks.xml", @xml
    described_class.set :xml => '<track>Track 2</track>', :at => "/tracks.xml", :select => "/tracks"
    squeeze(Scales::Storage::Sync.get_content("/tracks.xml")).should == squeeze(<<-XML
      <tracks>
        <track>Track 2</track>
      </tracks>
    XML
    )
  end
  
  it "replaces a node" do
    Scales::Storage::Sync.set_content "/tracks.xml", @xml
    described_class.replace :xml => '<track>Track 2</track>', :at => "/tracks.xml", :select => "/tracks/track"
    squeeze(Scales::Storage::Sync.get_content("/tracks.xml")).should == squeeze(<<-XML
      <tracks>
        <track>Track 2</track>
      </tracks>
    XML
    )
  end
  
  it "removes a node" do
    Scales::Storage::Sync.set_content "/tracks.xml", @xml
    described_class.remove :at => "/tracks.xml", :select => "/tracks/track"
    squeeze(Scales::Storage::Sync.get_content("/tracks.xml")).should == squeeze(<<-XML
      <tracks>
      </tracks>
    XML
    )
  end
  
  context Scales do
    
    it "appends a node" do
      Scales::Storage::Sync.set_content "/tracks.xml", @xml
      Scales.append :xml => '<track>Track 2</track>', :to => "/tracks.xml", :select => "/tracks"
      squeeze(Scales::Storage::Sync.get_content("/tracks.xml")).should == squeeze(<<-XML
        <tracks>
          <track>Track 1</track>
          <track>Track 2</track>
        </tracks>
      XML
      )
    end

    it "prepends a node" do
      Scales::Storage::Sync.set_content "/tracks.xml", @xml
      Scales.prepend :xml => '<track>Track 2</track>', :to => "/tracks.xml", :select => "/tracks"
      squeeze(Scales::Storage::Sync.get_content("/tracks.xml")).should == squeeze(<<-XML
        <tracks>
          <track>Track 2</track>
          <track>Track 1</track>
        </tracks>
      XML
      )
    end

    it "sets a node" do
      Scales::Storage::Sync.set_content "/tracks.xml", @xml
      Scales.set :xml => '<track>Track 2</track>', :at => "/tracks.xml", :select => "/tracks"
      squeeze(Scales::Storage::Sync.get_content("/tracks.xml")).should == squeeze(<<-XML
        <tracks>
          <track>Track 2</track>
        </tracks>
      XML
      )
    end

    it "replaces a node" do
      Scales::Storage::Sync.set_content "/tracks.xml", @xml
      Scales.replace :xml => '<track>Track 2</track>', :at => "/tracks.xml", :select => "/tracks/track"
      squeeze(Scales::Storage::Sync.get_content("/tracks.xml")).should == squeeze(<<-XML
        <tracks>
          <track>Track 2</track>
        </tracks>
      XML
      )
    end

    it "removes a node" do
      Scales::Storage::Sync.set_content "/tracks.xml", @xml
      Scales.remove :xml, :at => "/tracks.xml", :select => "/tracks/track"
      squeeze(Scales::Storage::Sync.get_content("/tracks.xml")).should == squeeze(<<-XML
        <tracks>
        </tracks>
      XML
      )
    end
    
  end
  
end