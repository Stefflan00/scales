require "scales-worker/boot/autoload"

module Scales
  module Worker
    autoload :Application,  "scales-worker/application"
    autoload :Job,          "scales-worker/job"
    autoload :Response,     "scales-worker/response"
    autoload :Worker,       "scales-worker/worker"
  end
end

require "scales-worker/version"
require "scales-worker/base"
