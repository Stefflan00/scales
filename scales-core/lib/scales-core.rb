require 'scales-core/boot/autoload'

module Scales
  autoload :Helper,   "scales-core/helper"
  autoload :Config,   "scales-core/config"
  autoload :Storage,  "scales-core/storage"
  autoload :Queue,    "scales-core/queue"
  autoload :PubSub,   "scales-core/pub_sub"
  autoload :Scalify,  "scales-core/scalify"
end

require "scales-core/version"
require "scales-core/base"
