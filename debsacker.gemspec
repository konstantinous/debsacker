# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'debsacker/version'

Gem::Specification.new do |spec|
  spec.name          = "debsacker"
  spec.version       = Debsacker::VERSION
  spec.authors       = ["Konstantin Khokhlov", "Aleksandr Fomin"]
  spec.email         = ["lazychyvak@gmail.com", "ll.wg.bin@gmail.com"]
  spec.summary       = %q{Debian packaging for Ruby and Ruby on Rails applications}
  spec.homepage      = "https://github.com/konstantinous/debsacker"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = 'debsacker'
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
end
