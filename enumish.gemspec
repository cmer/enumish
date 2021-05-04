# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'enumish/version'

Gem::Specification.new do |spec|
  spec.name          = "enumish"
  spec.version       = Enumish::VERSION
  spec.authors       = ["Carl Mercier"]
  spec.email         = ["foss@carlmercier.com"]

  spec.summary       = %q{Enum for ActiveRecord}
  spec.description   = %q{Create Enum-like values directly in the database for flexibility, power and supremacy.}
  spec.homepage      = "https://www.github.com/cmer/enumish"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "temping", "~> 3.9"
  spec.add_development_dependency "sqlite3"
  spec.add_runtime_dependency "activesupport", "~> 5.0"
  spec.add_runtime_dependency "activerecord", "~> 5.0"

end
