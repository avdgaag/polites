# frozen_string_literal: true

require_relative 'lib/ulysses/version'

Gem::Specification.new do |spec|
  spec.name = 'ulysses-nanoc'
  spec.version = Ulysses::VERSION
  spec.authors = ['Arjan van der Gaag']
  spec.email = ['arjan@arjanvandergaag.nl']

  spec.summary = 'Integrate the Ulysess gem with Nanoc.'
  spec.description = 'Use Ulysses\' .ulyz files as a data source in static sites generated with Nanoc.'
  spec.homepage = 'https://github.com/avdgaag/ulysses'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/avdgaag/ulysses'
  spec.metadata['changelog_uri'] = 'https://github.com/avdgaag/ulysses'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }.grep(/nanoc/)
  end
  spec.require_paths = ['lib']
  spec.add_dependency 'nanoc', '~> 4'
  spec.add_dependency 'ulysses', "~> #{Ulysses::VERSION}"
end