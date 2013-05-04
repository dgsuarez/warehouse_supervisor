# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'warehouse_supervisor/version'

Gem::Specification.new do |gem|
  gem.name          = "warehouse_supervisor"
  gem.version       = WarehouseSupervisor::VERSION
  gem.authors       = ["Diego Guerra"]
  gem.email         = ["diego.guerra.suarez@gmail.com"]
  gem.description   = %q{Easily create and run supervisord configuration files}
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/dgsuarez/warehouse_supervisor"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'thor'
  gem.add_development_dependency 'rspec'
end
