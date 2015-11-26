# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'coins_address_validator/version'

Gem::Specification.new do |spec|
  spec.name          = "coins_address_validator"
  spec.version       = CoinsAddressValidator::VERSION
  spec.authors       = ["Hothza"]
  spec.email         = ["hothza@users.noreply.github.com"]

#  if spec.respond_to?(:metadata)
#    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
#  end

  spec.summary       = %q{CoinsAddressValidator - gem which allows you to check if virtual coin address is valid and retrieve information about it.}
  spec.homepage      = "https://github.com/Hothza/coin_address_validator"
  spec.license       = "BSD"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"
end
