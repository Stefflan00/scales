require 'scales-core'

autoload :Rake, "scales-worker/boot/initializers/rake"

module Rake
  autoload :TaskLib, "scales-worker/boot/initializers/rake"
end