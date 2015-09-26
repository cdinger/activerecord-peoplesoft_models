# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'peoplesoft_models/version'

Gem::Specification.new do |spec|
  spec.name          = "activerecord-peoplesoft_models"
  spec.version       = PeoplesoftModels::VERSION
  spec.authors       = ["Chris Dinger"]
  spec.email         = ["ding0057@umn.edu"]
  spec.summary       = %q{ActiveRecord models for working with PeopleSoft tables}
  spec.description   = %q{A Rubygem that provides an easy way to build ActiveRecord models that represent PeopleSoft tables}
  spec.homepage      = "https://github.com/cdinger/activerecord-peoplesoft_models"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "composite_primary_keys", "~> 8.0"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "sqlite3", "~> 1.3.10"
  spec.add_development_dependency "activerecord-oracle_enhanced-adapter", "~> 1.5"
  spec.add_development_dependency "ruby-oci8", "~> 2.1" unless RUBY_PLATFORM == "java" || !ENV["SKIP_OCI8"].nil?
end
