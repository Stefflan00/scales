require 'scales-worker'

Scales.env = "test"

module Helpers
  
  def fixture(file)
    File.read(File.expand_path("../fixtures/#{file}", __FILE__))
  end
  
  def in_app_folder
    pwd = Dir.pwd
    Dir.chdir File.expand_path("../../../spec/app", __FILE__)
    yield
    Dir.chdir(pwd)
  end
  
  def in_process_thread
    thread = Thread.new do
      Thread.current[:post_process_queue] = []
      Thread.current[:redis_blocking]     = Scales::Storage::Sync.new_connection!
      Thread.current[:redis_nonblocking]  = Scales::Storage::Sync.new_connection!
      yield
    end.join
  end
  
  def squeeze string
    string.gsub(/(\n|\t|\r)/, ' ').gsub(/>\s*</, '><').squeeze(' ').strip
  end
  
  def squeeze_json json
    squeeze(json).gsub " ", ""
  end
end

RSpec.configure do |config|
  config.include Helpers
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.before(:suite) do
    Scales::Storage::Sync.flushall!
  end
end