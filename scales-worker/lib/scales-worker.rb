require "scales-worker/boot/autoload"

module Scales
  module Worker
    autoload :Application,  "scales-worker/application"
    autoload :Job,          "scales-worker/job"
    autoload :Response,     "scales-worker/response"
    autoload :Worker,       "scales-worker/worker"
    autoload :Pusher,       "scales-worker/pusher"
    autoload :Cache,        "scales-worker/cache"
    autoload :Path,         "scales-worker/path"
  end
  
  autoload :Up,             "scales/up"
end

require "scales-worker/version"
require "scales-worker/base"
