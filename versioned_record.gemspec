# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'versioned_record/version'

Gem::Specification.new do |spec|
  spec.name          = "versioned_record"
  spec.version       = VersionedRecord::VERSION
  spec.authors       = ["Dan Draper"]
  spec.email         = ["daniel@codehire.com"]
  spec.description   = %q{Version ActiveRecord models using composite primary keys}
  spec.summary       = %q{Version ActiveRecord models using composite primary keys}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_runtime_dependency "activerecord", "= 4.0.3"
  spec.add_runtime_dependency 'composite_primary_keys', '>= 6.0.5'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "pg"
  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "timecop"
end
