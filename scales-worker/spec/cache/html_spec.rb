require 'helper'

describe Scales::Worker::Cache::HTML do
  
  before(:each) do
    @html = <<-HTML
      <html>
        <body>
          <div><h1>Tracks</h1></div>
          <div id="tracks">
            <p id="track1">Track 1</p>
          </div>
        </body>
      </html>
    HTML
  end
  
  it "checks for full html page" do
    described_class.instance_eval do
      @html = <<-HTML
        <html>
          <body>
            <div><h1>Tracks</h1></div>
            <div id="tracks">
              <p id="track1">Track 1</p>
            </div>
          </body>
        </html>
      HTML
      is_html_page?(@html)
    end.should be_true
      
    described_class.instance_eval{ is_html_page?("<p>Hello World</p>") }.should be_false
  end
  
  it "raises exception on missing path" do
    expect{ described_class.append :html => '<p id="track2">Track 2</p>' }.to raise_error 'No path defined like this :to => "/tracks"'
  end
  
  it "raises exception on missing selector" do
    expect{ described_class.append :html => '<p id="track2">Track 2</p>', :to => "/something" }.to raise_error 'No selector defined like this :select => "#tracks"'
  end
  
  it "appends a node" do
    Scales::Storage::Sync.set_content "/tracks", @html
    described_class.append :html => '<p id="track2">Track 2</p>', :to => "/tracks", :select => "#tracks"
    squeeze(Scales::Storage::Sync.get_content("/tracks")).should == squeeze(<<-HTML
      <html>
        <body>
          <div><h1>Tracks</h1></div>
          <div id="tracks">
            <p id="track1">Track 1</p>
            <p id="track2">Track 2</p>
          </div>
        </body>
      </html>
    HTML
    )
  end
  
  it "prepends a node" do
    Scales::Storage::Sync.set_content "/tracks", @html
    described_class.prepend :html => '<p id="track2">Track 2</p>', :to => "/tracks", :select => "#tracks"
    squeeze(Scales::Storage::Sync.get_content("/tracks")).should == squeeze(<<-HTML
      <html>
        <body>
          <div><h1>Tracks</h1></div>
          <div id="tracks">
            <p id="track2">Track 2</p>
            <p id="track1">Track 1</p>
          </div>
        </body>
      </html>
    HTML
    )
  end
  
  it "sets a node" do
    Scales::Storage::Sync.set_content "/tracks", @html
    described_class.set :html => '<p id="track2">Track 2</p>', :at => "/tracks", :select => "#tracks"
    squeeze(Scales::Storage::Sync.get_content("/tracks")).should == squeeze(<<-HTML
      <html>
        <body>
          <div><h1>Tracks</h1></div>
          <div id="tracks">
            <p id="track2">Track 2</p>
          </div>
        </body>
      </html>
    HTML
    )
  end
  
  it "replaces a node" do
    Scales::Storage::Sync.set_content "/tracks", @html
    described_class.replace :html => '<p id="track2">Track 2</p>', :at => "/tracks", :select => "#tracks"
    squeeze(Scales::Storage::Sync.get_content("/tracks")).should == squeeze(<<-HTML
      <html>
        <body>
          <div><h1>Tracks</h1></div>
          <p id="track2">Track 2</p>
        </body>
      </html>
    HTML
    )
  end
  
  it "removes a node" do
    Scales::Storage::Sync.set_content "/tracks", @html
    described_class.remove :at => "/tracks", :select => "#tracks"
    squeeze(Scales::Storage::Sync.get_content("/tracks")).should == squeeze(<<-HTML
      <html>
        <body>
          <div><h1>Tracks</h1></div>
        </body>
      </html>
    HTML
    )
  end
  
  context Scales do
    
    it "appends a node" do
      Scales::Storage::Sync.set_content "/tracks", @html
      Scales.append :html => '<p id="track2">Track 2</p>', :to => "/tracks", :select => "#tracks"
      squeeze(Scales::Storage::Sync.get_content("/tracks")).should == squeeze(<<-HTML
        <html>
          <body>
            <div><h1>Tracks</h1></div>
            <div id="tracks">
              <p id="track1">Track 1</p>
              <p id="track2">Track 2</p>
            </div>
          </body>
        </html>
      HTML
      )
    end

    it "prepends a node" do
      Scales::Storage::Sync.set_content "/tracks", @html
      Scales.prepend :html => '<p id="track2">Track 2</p>', :to => "/tracks", :select => "#tracks"
      squeeze(Scales::Storage::Sync.get_content("/tracks")).should == squeeze(<<-HTML
        <html>
          <body>
            <div><h1>Tracks</h1></div>
            <div id="tracks">
              <p id="track2">Track 2</p>
              <p id="track1">Track 1</p>
            </div>
          </body>
        </html>
      HTML
      )
    end

    it "sets a node" do
      Scales::Storage::Sync.set_content "/tracks", @html
      Scales.set :html => '<p id="track2">Track 2</p>', :at => "/tracks", :select => "#tracks"
      squeeze(Scales::Storage::Sync.get_content("/tracks")).should == squeeze(<<-HTML
        <html>
          <body>
            <div><h1>Tracks</h1></div>
            <div id="tracks">
              <p id="track2">Track 2</p>
            </div>
          </body>
        </html>
      HTML
      )
    end

    it "replaces a node" do
      Scales::Storage::Sync.set_content "/tracks", @html
      Scales.replace :html => '<p id="track2">Track 2</p>', :at => "/tracks", :select => "#tracks"
      squeeze(Scales::Storage::Sync.get_content("/tracks")).should == squeeze(<<-HTML
        <html>
          <body>
            <div><h1>Tracks</h1></div>
            <p id="track2">Track 2</p>
          </body>
        </html>
      HTML
      )
    end

    it "removes a node" do
      Scales::Storage::Sync.set_content "/tracks", @html
      Scales.remove :html, :at => "/tracks", :select => "#tracks"
      squeeze(Scales::Storage::Sync.get_content("/tracks")).should == squeeze(<<-HTML
        <html>
          <body>
            <div><h1>Tracks</h1></div>
          </body>
        </html>
      HTML
      )
    end
    
  end
  
end