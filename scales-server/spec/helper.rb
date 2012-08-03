require 'scales-server'

module Helpers
  @@pids = []
  
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
  
  def in_app_folder
    pwd = Dir.pwd
    Dir.chdir File.expand_path("../../../spec/app", __FILE__)
    yield
    Dir.chdir(pwd)
  end
  
  def fixture(file)
    File.read(File.expand_path("../fixtures/#{file}", __FILE__))
  end
  
  def squeeze string
    string.gsub(/(\n|\t|\r)/, ' ').gsub(/>\s*</, '><').squeeze(' ').strip
  end
  
  def spawn_server(port = 3000)
    @@pids << fork do
      trap('INT') do
        exit 0
      end
      
      Scales::Storage::Sync.force_reconnect!
      
      ARGV << "-p" << port.to_s
      Scales::Server.run!
    end
    
    puts "Waiting for server on port #{port} to spawn ..."
    sleep 2
  end
  
  def spawn_proxy(port = 3000, backends)
    @@pids << fork do
      trap('INT') do
        exit 0
      end
      
      Scales::Storage::Sync.force_reconnect!
      
      Scales::Server::Proxy::Backend.add(backends)
      Scales::Server::Proxy.run!("0.0.0.0", port)
    end
    
    puts "Waiting for proxy on port #{port} to spawn ..."
    sleep 2
  end
  
  def kill_spawned_servers
    @@pids.each do |pid|
      Process.kill("INT", pid)
      Process.wait
    end
    @@pids = []
  end
  
end

RSpec.configure do |config|
  config.include Helpers
  config.include Goliath::TestHelper
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.before(:suite) do
    Scales::Storage::Sync.flushall!
  end
end