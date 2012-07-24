require 'colorize'
require 'json'
require 'yaml'

autoload :Redis,          "scales-core/boot/initializers/redis"
autoload :EventMachine,   "scales-core/boot/initializers/em"
autoload :Thor,           "scales-core/boot/initializers/thor"

module EventMachine
  autoload :Synchrony,    "scales-core/boot/initializers/em"
  autoload :Hiredis,      "scales-core/boot/initializers/em"
end

module EM
  autoload :Synchrony,    "scales-core/boot/initializers/em"
  autoload :Hiredis,      "scales-core/boot/initializers/em"
end

ENV['SCALES_ENV'] ||= "development"