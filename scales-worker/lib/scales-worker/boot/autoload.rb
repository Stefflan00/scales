require 'scales-core'
require 'logger'

autoload :Rake,     "scales-worker/boot/initializers/rake"
autoload :Nokogiri, "scales-worker/boot/initializers/nokogiri"
autoload :JsonPath, "scales-worker/boot/initializers/jsonpath"

module Rake
  autoload :TaskLib, "scales-worker/boot/initializers/rake"
end