require 'helper_application'

include Helpers

in_app_folder do
  puts "Launching Application ..."
  ScalesApplication.run!
end

at_exit do
  puts "Stopping Application ..."
  ScalesApplication.stop!
end
