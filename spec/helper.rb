require 'scales-core'
require "net/http"
require "uri"

Scales.env = "test"

module Helpers
  @@worker, @@server, @@scaleup = nil, nil, nil
  
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
    Dir.chdir File.expand_path("../app", __FILE__)
    out = yield
    Dir.chdir(pwd)
    out
  end
  
  def in_temp_folder
    pwd = Dir.pwd
    Dir.mkdir "spec/tmp"
    Dir.chdir "spec/tmp"
    begin
      yield
    rescue Exception => e
      raise e
    ensure
      Dir.chdir(pwd)
      FileUtils.rm_rf("spec/tmp")
    end
  end
  
  def squeeze string
    string.gsub(/(\n|\t|\r)/, ' ').gsub(/>\s*</, '><').squeeze(' ').strip
  end
  
  def launch_worker!
    puts "\nLaunching scales-worker".green
    in_app_folder do
      @@worker = fork do
        exec "scales-worker"
      end
    end
    sleep 10
  end
  
  def kill_worker!
    `kill -9 #{@@worker}`
  end
  
  def launch_server!
    puts "\nLaunching scales-server".green
    in_app_folder do
      @@server = fork do
        exec "scales-server"
      end
    end
    sleep 4
  end
  
  def kill_server!
    `kill -9 #{@@server}`
  end
  
  def get url
    uri     = URI.parse(url)
    http    = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)

    http.request(request)
  end
  
  def post url, data = {}
    uri = URI.parse(url)
    Net::HTTP.post_form(uri, data)
  end
  
end

RSpec.configure do |config|
  config.include Helpers
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.before(:suite) do
    Scales::Storage::Sync.flushall!
  end
end