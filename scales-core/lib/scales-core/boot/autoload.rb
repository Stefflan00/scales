require 'json'

autoload :Redis,          "scales-core/boot/initializers/redis"
autoload :EventMachine,   "scales-core/boot/initializers/em"

module EventMachine
  autoload :Synchrony,    "scales-core/boot/initializers/em"
  autoload :Hiredis,      "scales-core/boot/initializers/em"
end

module EM
  autoload :Synchrony,    "scales-core/boot/initializers/em"
  autoload :Hiredis,      "scales-core/boot/initializers/em"
end