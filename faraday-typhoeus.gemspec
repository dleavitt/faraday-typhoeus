# frozen_string_literal: true

require_relative 'lib/faraday/typhoeus/version'

Gem::Specification.new do |spec|
  spec.name = 'faraday-typhoeus'
  spec.version = Faraday::Typhoeus::VERSION
  spec.authors = ['Daniel Leavitt']
  spec.email = ['daniel.leavitt@gmail.com']

  spec.summary = 'Faraday adapter for Typhoeus'
  spec.description = 'Faraday adapter for Typhoeus'
  spec.homepage = 'https://github.com/dleavitt/faraday-typhoeus'
  spec.license = 'MIT'

  spec.required_ruby_version = Gem::Requirement.new('>= 2.6.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/dleavitt/faraday-typhoeus'
  spec.metadata['changelog_uri'] = 'https://github.com/dleavitt/faraday-typhoeus'

  spec.files = Dir.glob('lib/**/*') + %w[README.md LICENSE.md]
  spec.require_paths = ['lib']

  spec.add_dependency 'faraday', '~> 2.0'
  spec.add_dependency 'typhoeus', '~> 1.4'
end
