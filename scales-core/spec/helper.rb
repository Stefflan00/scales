require 'scales-core'

module Helpers
  
  def async
    if EM.reactor_running?
      yield
    else
      out = nil
      EM.synchrony do
        out = yield
        EM.stop
      end
      out
    end
  end
  
  def fixture(file)
    File.read(File.expand_path("../fixtures/#{file}", __FILE__))
  end
  
  def in_app_folder
    pwd = Dir.pwd
    Dir.chdir File.expand_path("../fixtures/app", __FILE__)
    yield
    Dir.chdir(pwd)
  end
  
end

RSpec.configure do |config|
  config.include Helpers
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.before(:suite) do
    Scales::Storage::Sync.flushall!
  end
end