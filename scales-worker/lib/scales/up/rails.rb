require 'scales-worker'

ENV['RAILS_ENV'] ||= "development"

Scales::Up.application = Scales::Worker::Application::Rails