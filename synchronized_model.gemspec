# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'synchronized_model/version'

Gem::Specification.new do |spec|
  spec.name          = 'synchronized_model'
  spec.version       = SynchronizedModel::VERSION
  spec.authors       = ['Eric Cranston']
  spec.email         = ['ecranston@westernmilling.com']

  spec.summary       = 'Helper library for synchronizing model data using ' \
                       'messages'
  spec.description   = 'Helper library for synchronizing model data using ' \
                       'messages'
  spec.homepage      = 'https://github.com/westernmilling/synchronized_model'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rspec_junit_formatter'
  spec.add_development_dependency 'rubocop', '~> 0.54.0'
  spec.add_development_dependency 'simplecov'
end
