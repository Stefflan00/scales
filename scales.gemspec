# -*- encoding: utf-8 -*-
require File.expand_path('../lib/scales/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Thomas Fankhauser"]
  gem.email         = ["tommylefunk@googlemail.com"]
  gem.description   = %q{Super Scale System}
  gem.summary       = %q{Super Scale System}
  gem.homepage      = "http://itscales.org"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "scales"
  gem.require_paths = ["lib"]
  gem.version       = Scales::VERSION
  
  # Development
  gem.add_development_dependency "rake",  ">= 0.9.2.2"
  gem.add_development_dependency "rspec", ">= 2.11"
  
  # Production
  gem.add_dependency "redis",         ">= 3.0.1"
  gem.add_dependency "eventmachine",  ">= 1.0.0.beta.4"
  gem.add_dependency "em-synchrony",  ">= 1.0.2"
  gem.add_dependency "em-hiredis",    ">= 0.1.1"
  gem.add_dependency "goliath",       ">= 1.0.0.beta.1"
  
end
