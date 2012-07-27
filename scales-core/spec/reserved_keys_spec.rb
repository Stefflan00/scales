require 'helper'

describe Scales::Storage::ReservedKeys do
  
  it "allows to add a regex" do
    described_class.add /^scales/
    described_class.expressions.include?(/^scales/).should be_true
  end
  
  it "raises an exception if key is reserved" do
    described_class.add /^scales/
    expect{ described_class.validate!("scales_request") }.to raise_exception "scales_request is a reserved key, please choose another one!"
    expect{ described_class.validate!("some") }.not_to raise_exception
  end
  
end