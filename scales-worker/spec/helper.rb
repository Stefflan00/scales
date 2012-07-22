require 'scales-worker'

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
      yield
    end.join
  end
end

RSpec.configure do |config|
  config.include Helpers
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.before(:suite) do
    Scales::Storage::Sync.flushall!
  end
end