require 'scales-core'

autoload :Rake,     "scales-worker/boot/initializers/rake"
autoload :Nokogiri, "scales-worker/boot/initializers/nokogiri"

module Rake
  autoload :TaskLib, "scales-worker/boot/initializers/rake"
end