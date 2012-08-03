# -*- encoding: utf-8 -*-
require File.expand_path('../lib/scales-server/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Thomas Fankhauser"]
  gem.email         = ["tommylefunk@googlemail.com"]
  gem.description   = %q{Super Scale Caching Framework - Server}
  gem.summary       = %q{Serves all requests asynchronous from the cache and puts jobs into the request queue for the workers.}
  gem.homepage      = "http://itscales.org"

  gem.files         = Dir['LICENSE', 'lib/**/*']
  gem.executables   = Dir['bin/*'].map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "scales-server"
  gem.require_paths = ["lib"]
  gem.version       = Scales::Server::VERSION
  
  # Dependencies
  gem.add_dependency  "rake",         ">= 0.9.2.2"
  gem.add_dependency  "rspec",        ">= 2.11"
  gem.add_dependency  "scales-core",  Scales::Server::VERSION
  gem.add_dependency  "goliath",      ">= 1.0.0.beta.1"
  gem.add_dependency  "em-proxy",     ">= 0.1.6"
end
