# -*- encoding: utf-8 -*-
require File.expand_path('../lib/scales-monitor/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Thomas Fankhauser"]
  gem.email         = ["tommylefunk@googlemail.com"]
  gem.description   = %q{Scales monitor server}
  gem.summary       = %q{Scales monitor server}
  gem.homepage      = "http://itscales.org"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "scales-monitor"
  gem.require_paths = ["lib"]
  gem.version       = Scales::Monitor::VERSION
  
  # Dependencies
  gem.add_dependency  "rake",         ">= 0.9.2.2"
  gem.add_dependency  "rspec",        ">= 2.11"
  gem.add_dependency  "scales-core",  ">= 0.0.1"
  gem.add_dependency  "goliath",      ">= 1.0.0.beta.1"
end
