# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'taxcalendario/client/version'

Gem::Specification.new do |spec|
  spec.name          = "taxcalendario-client"
  spec.version       = Taxcalendario::Client::VERSION
  spec.authors       = ["Franklin Ronald"]
  spec.email         = ["franklin@wiselabs.com.br"]
  spec.summary       = "Cliente da API TaxWeb Calendarioo"
  spec.description   = "Cliente REST para a API v1 do TaxWeb Calendario na nuvem."
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
