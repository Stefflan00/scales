# -*- encoding: utf-8 -*-
require File.expand_path('../lib/scales-server/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Thomas Fankhauser"]
  gem.email         = ["tommylefunk@googlemail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "scales-server"
  gem.require_paths = ["lib"]
  gem.version       = Scales::Server::VERSION
  
  # Development
  gem.add_development_dependency    "rake",  ">= 0.9.2.2"
  gem.add_development_dependency    "rspec", ">= 2.11"
  
  # Production
  gem.add_dependency "scales-core", ">= 0.0.1"
  gem.add_dependency "goliath",     ">= 1.0.0.beta.1"
  
end
