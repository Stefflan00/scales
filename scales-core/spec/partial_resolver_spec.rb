require 'helper'

describe Scales::Helper::PartialResolver do
  
  before(:all) do
    @html = <<-HTML
      <html>
        <body>
          <div id="header">Scales.partial "header"</div>
          <div id="page">
            <h1>Hello World</h1>
          </div>
        </body>
      </html>
    HTML
    
    @header = "<div>Header with Items: <div>Scales.partial 'items'</div></div>"
    @items  = "<ul><li>Item 1</li><li>Item 2</li></ul>"
  end
  
  it "checks if a string includes a partial" do
    described_class.includes_partial?('Scales.partial "header"').should be_true
    described_class.includes_partial?("Scales.partial 'header'").should be_true
    described_class.includes_partial?(@html).should be_true
  end
  
  it "returns value if key doesn't contain a partial" do
    Scales::Storage::Sync.set_content "/tracks", "A text without partials"
    described_class.resolve(Scales::Storage::Sync.connection, "scales_resource_/tracks").should == "A text without partials"
  end
  
  it "resolves a partial" do
    Scales::Storage::Sync.set_content "header", "<p>The header</p>"
    described_class.resolve_partial(Scales::Storage::Sync.connection, @html).should == @html.gsub('Scales.partial "header"', "<p>The header</p>")
  end
  
  it "multi resolves partials" do
    Scales::Storage::Sync.set_content "/tracks", @html
    Scales::Storage::Sync.set_content "header", @header
    Scales::Storage::Sync.set_content "items", @items
    
    described_class.resolve(Scales::Storage::Sync.connection, "scales_resource_/tracks").should == @html.gsub('Scales.partial "header"', @header).gsub("Scales.partial 'items'", @items)
  end
  
end