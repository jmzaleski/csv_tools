# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'csv_tools/version'

Gem::Specification.new do |spec|
  spec.name          = "csv_tools"
  spec.version       = CSVTools::VERSION
  spec.authors       = ["Joey Freund"]
  spec.email         = ["joeyfreund@gmail.com"]

  spec.summary       = %q{Command-line tools for CSV file manipulation.}
  spec.description   = %q{Manipulate CSV files as if they were SQL tables.}
  spec.homepage      = "https://github.com/joeyfreund/csv_tools"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
