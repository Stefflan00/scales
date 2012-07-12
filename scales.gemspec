# -*- encoding: utf-8 -*-
require File.expand_path('../lib/scales/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Thomas Fankhauser"]
  gem.email         = ["tommylefunk@googlemail.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = "http://itscales.org"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "scales"
  gem.require_paths = ["lib"]
  gem.version       = Scales::VERSION
  
  # Development
  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  
  # Production
  
end
