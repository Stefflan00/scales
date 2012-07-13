autoload :Redis,      "scales/initializers/redis"
autoload :EM,         "scales/initializers/em"

module Scales
  autoload :Helper,   "scales/helper"
  autoload :Config,   "scales/config"
  autoload :Storage,  "scales/storage"
  autoload :Queue,    "scales/queue"
end

require "scales/version"
require "scales/base"