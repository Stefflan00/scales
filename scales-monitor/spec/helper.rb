require 'scales-monitor'
require "net/http"
require "uri"

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
  
  def fixture(file)
    File.read(File.expand_path("../fixtures/#{file}", __FILE__))
  end
  
  def squeeze string
    string.gsub(/(\n|\t|\r)/, ' ').gsub(/>\s*</, '><').squeeze(' ').strip
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