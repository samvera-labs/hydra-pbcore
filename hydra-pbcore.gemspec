# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'hydra-pbcore/version'

Gem::Specification.new do |gem|
  gem.authors       = ["Adam Wead"]
  gem.email         = ["amsterdamos@gmail.com"]
  gem.description   = %q{A Hydra gem that offers PBCore datastream definitions using OM}
  gem.summary       = %q{A Hydra gem that offers PBCore datastream definitions using OM}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "hydra-pbcore"
  gem.require_paths = ["lib"]
  gem.version       = HydraPbcore::VERSION

  # Dependencies
  gem.add_dependency('nokogiri')
  gem.add_dependency('om')
  gem.add_dependency('active-fedora')
  gem.add_dependency('solrizer', '~> 2.0.0.rc3' )
  gem.add_development_dependency('yard')
  gem.add_development_dependency('redcarpet')
  # For Development
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'debugger'
  gem.add_development_dependency 'rdoc'
  gem.add_development_dependency 'equivalent-xml'
end
