# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'capistrano-scm-artifact/version'

Gem::Specification.new do |spec|
  spec.name          = "capistrano-scm-artifact"
  spec.version       = Capistrano::Scm::Artifact::VERSION
  spec.authors       = ["Brian Racer"]
  spec.email         = ["bracer@gmail.com"]
  spec.summary       = %q{Deploy artifact archives with Capistrano 3.}
  spec.homepage      = "https://github.com/anveo/capistrano-scm-artifact"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "capistrano", "~> 3.0"
  spec.add_dependency "fog"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
