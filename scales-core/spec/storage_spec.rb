require 'helper'

describe Scales::Storage::Sync do
  
  it "should set and get a key" do
    Scales::Storage::Sync.set "test_key", "a test value"
    Scales::Storage::Sync.get("test_key").should == "a test value"
  end
  
  context "partials" do
    
    before(:each) do
      Scales.config.partials = true
      Scales::Storage::Sync.flushall!
    end
    
    it "resolves partials" do
      
      @html = <<-HTML
        <html>
          <body>
            <div id="header">Scales.partial "_header"</div>
            <div id="page">
              <h1>Hello World</h1>
            </div>
          </body>
        </html>
      HTML
      
      @header = <<-HTML
        <ul>
          <li>Home</li>
          <li>Tracks</li>
          Scales.partial "_sub_header"
        </ul>
      HTML
      
      @sub_header = <<-HTML
        <ul>
          <li>Sub 1</li>
          <li>Sub 2</li>
        </ul>
      HTML
      
      Scales::Storage::Sync.set "/tracks",      @html
      Scales::Storage::Sync.set "_header",      @header
      Scales::Storage::Sync.set "_sub_header",  @sub_header
      
      squeeze(Scales::Storage::Sync.get("/tracks", true)).should == squeeze(@html.gsub('Scales.partial "_header"', @header).gsub('Scales.partial "_sub_header"', @sub_header))
    end
    
  end
  
end

describe Scales::Storage::Async do
  
  it "should set and get a key" do
    async do
      Scales::Storage::Async.set("test_key", "a test value") do
        Scales::Storage::Async.get("test_key") do |value|
          value.should == "a test value"
        end
      end
    end
  end
  
  context "partials" do
    
    before(:each) do
      Scales.config.partials = true
      Scales::Storage::Sync.flushall!
    end
    
    it "resolves partials" do
      
      @html = <<-HTML
        <html>
          <body>
            <div id="header">Scales.partial "_header"</div>
            <div id="page">
              <h1>Hello World</h1>
            </div>
          </body>
        </html>
      HTML
      
      @header = <<-HTML
        <ul>
          <li>Home</li>
          <li>Tracks</li>
          Scales.partial "_sub_header"
        </ul>
      HTML
      
      @sub_header = <<-HTML
        <ul>
          <li>Sub 1</li>
          <li>Sub 2</li>
        </ul>
      HTML
      
      async do
        Scales::Storage::Async.set "/tracks",      @html
        Scales::Storage::Async.set "_header",      @header
        Scales::Storage::Async.set "_sub_header",  @sub_header
      
        squeeze(Scales::Storage::Async.get("/tracks", true)).should == squeeze(@html.gsub('Scales.partial "_header"', @header).gsub('Scales.partial "_sub_header"', @sub_header))
      end
    end
    
  end
  
end

