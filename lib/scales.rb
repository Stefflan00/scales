require 'scales/autoload'

module Scales
  autoload :Helper,     "scales/helper"
  autoload :Config,     "scales/config"
  autoload :Storage,    "scales/storage"
  autoload :Queue,      "scales/queue"
  autoload :Server,     "scales/server"
  autoload :Dispatch,   "scales/dispatch"
  autoload :Lookup,     "scales/lookup"
end

require "scales/version"
require "scales/base"