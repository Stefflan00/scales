require "scales-monitor/boot/autoload"

module Scales
  module Monitor
    autoload :Monitor,    "scales-monitor/monitor"
    autoload :WebSocket,  "scales-monitor/web_socket"
  end
end

require "scales-monitor/version"
require "scales-monitor/base"
