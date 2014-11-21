# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nominal/version'

Gem::Specification.new do |spec|
  spec.name          = "nominal"
  spec.version       = Nominal::VERSION
  spec.authors       = ["JuanKu"]
  spec.email         = ["juanku@nominal.mx"]
  spec.summary       = %q{Librería para conectarse a api.nominal.mx}
  spec.description   = %q{Librería para conectarse a api.nominal.mx}
  spec.homepage      = "https://www.nominal.mx"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "faraday"
  spec.add_development_dependency "json"
  spec.add_development_dependency "mime-types"
  spec.add_development_dependency "nokogiri", "~> 1.6.2.1"
  spec.add_development_dependency "actionview"
  spec.add_development_dependency "openssl_pkcs8"

end
