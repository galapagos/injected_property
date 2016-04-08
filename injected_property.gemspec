# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'injected_property/version'

Gem::Specification.new do |spec|
  spec.name          = 'injected_property'
  spec.version       = InjectedProperty::VERSION
  spec.authors       = ['galapagos', 'k-motoyan']
  spec.email         = ['kenta.motoyanagi@glpgs.com']

  spec.summary       = 'injected_property is gem making it possible to inject processing for accessors.'
  spec.homepage      = 'https://github.com/galapagos/injected_property'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`
                         .split("\x0")
                         .reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 4.2'

  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rspec-its'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'codeclimate-test-reporter'
end
