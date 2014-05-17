# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'quotes/version'

Gem::Specification.new do |spec|
  spec.name          = "quotes"
  spec.version       = Quotes::VERSION
  spec.authors       = ["Dax"]
  spec.email         = ["d.dax@email.com"]
  spec.summary       = %q{source for quotes}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "kindleclippings",  "~>1.3.3"
  spec.add_dependency "nokogiri",         "~>1.6.1"
  spec.add_dependency "sqlite3",          "~>1.3.9"
  spec.add_dependency "sequel",           "~>4.10.0"

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "minitest-spec"
end
