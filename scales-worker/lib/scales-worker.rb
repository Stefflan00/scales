require 'bundler/setup'
require "scales-worker/boot/autoload"

module Scales
  module Worker
    autoload :Application,  "scales-worker/application"
    autoload :Worker,       "scales-worker/worker"
  end
end

require "scales-worker/version"
require "scales-worker/base"
