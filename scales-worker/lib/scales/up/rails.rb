require 'scales-worker'

Scales.try_to_setup_env!
Scales::Up.application = Scales::Worker::Application::Rails