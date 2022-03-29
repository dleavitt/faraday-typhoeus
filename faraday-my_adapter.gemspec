# frozen_string_literal: true

require_relative 'lib/faraday/my_adapter/version'

Gem::Specification.new do |spec|
  spec.name = 'faraday-my_adapter'
  spec.version = Faraday::MyAdapter::VERSION
  spec.authors = ['Your Name']
  spec.email = ['your_name@gmail.com']

  spec.summary = 'Faraday adapter for MyAdapter'
  spec.description = 'Faraday adapter for MyAdapter'
  spec.homepage = 'https://github.com/lostisland/faraday-my_adapter'
  spec.license = 'MIT'

  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/lostisland/faraday-my_adapter'
  spec.metadata['changelog_uri'] = 'https://github.com/lostisland/faraday-my_adapter'

  spec.files = Dir.glob('lib/**/*') + %w[README.md LICENSE.md]
  spec.require_paths = ['lib']

  spec.add_development_dependency 'faraday', '~> 1.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov', '~> 0.19.0'

  spec.add_development_dependency 'multipart-parser', '~> 0.1.1'
  spec.add_development_dependency 'webmock', '~> 3.4'
end
