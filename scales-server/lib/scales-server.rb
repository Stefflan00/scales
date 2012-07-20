require 'scales-server/boot/autoload'

module Scales
  module Server
    autoload :ContentType,  "scales-server/content_type"
    autoload :Server,       "scales-server/server"
    autoload :Dispatch,     "scales-server/dispatch"
  end
end

require "scales-server/version"
require "scales-server/base"