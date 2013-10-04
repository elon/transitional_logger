# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'transitional_logger'

Gem::Specification.new do |spec|
  spec.name          = "transitional_logger"
  spec.version       = TransitionalLogger::VERSION
  spec.authors       = ["Elon Flegenheimer"]
  spec.email         = ["elonf@hotmail.com"]
  spec.description   = "Singleton logger available in all Objects that can transition destinations."
  spec.summary       = "Singleton logger available in all Objects that can transition destinations."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "mocha"
end
