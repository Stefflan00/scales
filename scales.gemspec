# -*- encoding: utf-8 -*-
require File.expand_path('../version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Thomas Fankhauser"]
  gem.email         = ["tommylefunk@googlemail.com"]
  gem.summary       = %q{Super Scale Caching Framework}
  gem.description   = %q{Scaleable caching framework with 100% cache coverage, async server instances and sync worker instances supporting rack applications like Rails.}
  gem.homepage      = "http://itscales.org"

  gem.executables   = []
  gem.name          = "scales-framework"
  gem.version       = Scales::VERSION
  gem.required_ruby_version     = '>= 1.9.3'
  
  # Development
  gem.add_development_dependency "rake",  ">= 0.9.2.2"
  gem.add_development_dependency "rspec", ">= 2.11"
  
  # Production
  gem.add_dependency "scales-core",     Scales::VERSION
  gem.add_dependency "scales-server",   Scales::VERSION
  gem.add_dependency "scales-worker",   Scales::VERSION
  gem.add_dependency "scales-monitor",  Scales::VERSION
end
