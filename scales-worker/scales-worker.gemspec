# -*- encoding: utf-8 -*-
require File.expand_path('../lib/scales-worker/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Thomas Fankhauser"]
  gem.email         = ["tommylefunk@googlemail.com"]
  gem.description   = %q{Super Scale Caching Framework - Worker}
  gem.summary       = %q{Launches an instance of a rack app like Rails and processes jobs from the request queue.}
  gem.homepage      = "http://itscales.org"

  gem.files         = Dir['LICENSE', 'lib/**/*']
  gem.executables   = Dir['bin/*'].map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "scales-worker"
  gem.require_paths = ["lib"]
  gem.version       = Scales::Worker::VERSION
  
  # Dependencies
  gem.add_dependency "scales-core",  Scales::Worker::VERSION
  gem.add_dependency "rails",        ">= 3.2.6"
  gem.add_dependency "sqlite3",      ">= 1.3.6"
  gem.add_dependency "rspec",        ">= 2.11"
  gem.add_dependency "rake",         ">= 0.9.2.2"
  gem.add_dependency "nokogiri",     ">= 1.5.5"
  gem.add_dependency "jsonpath",     ">= 0.5.0"
end
