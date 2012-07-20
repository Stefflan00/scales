# -*- encoding: utf-8 -*-
require File.expand_path('../lib/scales-worker/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Thomas Fankhauser"]
  gem.email         = ["tommylefunk@googlemail.com"]
  gem.description   = %q{Scales Worker}
  gem.summary       = %q{Takes requests out of the queue and processes them}
  gem.homepage      = "http://itscales.org"

  gem.files         = Dir['LICENSE', 'lib/**/*']
  gem.executables   = Dir['bin/*'].map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "scales-worker"
  gem.require_paths = ["lib"]
  gem.version       = Scales::Worker::VERSION
  
  # Dependencies
  gem.add_dependency  "scales-core",  ">= 0.0.1"
  gem.add_dependency  "rails",        ">= 3.2.6"
  gem.add_dependency  "sqlite3",      ">= 1.3.6"
  gem.add_dependency  "rspec",        ">= 2.11"
  gem.add_dependency  "rake",         ">= 0.9.2.2"
end
