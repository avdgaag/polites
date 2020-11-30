# frozen_string_literal: true

require_relative 'lib/polites/version'

Gem::Specification.new do |spec|
  spec.name = 'polites'
  spec.version = Polites::VERSION
  spec.authors = ['Arjan van der Gaag']
  spec.email = ['arjan@arjanvandergaag.nl']

  spec.summary = 'Work with Polites files from Ruby'
  spec.description = 'Polites is a gem that can read Polites\' .ulyz files and transform their contents to HTML.'
  spec.homepage = 'https://github.com/avdgaag/polites'
  spec.license = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.4.0')

  spec.metadata['allowed_push_host'] = 'https://rubygems.org'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/avdgaag/polites'
  spec.metadata['changelog_uri'] = 'https://github.com/avdgaag/polites'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features|nanoc)/}) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'rubyzip'
end
