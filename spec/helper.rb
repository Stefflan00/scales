require 'scales'

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
  
end

RSpec.configure do |config|
  config.include Helpers
  config.treat_symbols_as_metadata_keys_with_true_values = true
end