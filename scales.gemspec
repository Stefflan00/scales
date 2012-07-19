# -*- encoding: utf-8 -*-
require File.expand_path('../version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Thomas Fankhauser"]
  gem.email         = ["tommylefunk@googlemail.com"]
  gem.summary       = %q{Full-Stack Super Scale System}
  gem.description   = %q{Super Scale System}
  gem.homepage      = "http://itscales.org"

  gem.executables   = []
  gem.name          = "scales"
  gem.version       = Scales::VERSION
  gem.required_ruby_version     = '>= 1.9.3'
  
  # Development
  gem.add_development_dependency "rake",  ">= 0.9.2.2"
  gem.add_development_dependency "rspec", ">= 2.11"
  
  # Production
  gem.add_dependency "scales-core",   Scales::VERSION
  gem.add_dependency "scales-server", Scales::VERSION
  gem.add_dependency "scales-worker", Scales::VERSION
end
