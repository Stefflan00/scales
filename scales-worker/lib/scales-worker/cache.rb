module Scales
  module Worker
    module Cache
      autoload :Push,     "scales-worker/cache/push"
      autoload :Destroy,  "scales-worker/cache/destroy"
      autoload :Update,   "scales-worker/cache/update"
    end
  end
end