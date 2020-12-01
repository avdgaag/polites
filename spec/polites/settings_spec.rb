# frozen_string_literal: true

require 'polites/settings'

module Polites
  RSpec.describe Settings do
    it 'combines plist files from a directory' do
      skip 'Not supported on CI' if ENV['CI']
      settings = Settings.from_directory('spec/fixtures')
      expect(settings['defaultPathExtensions']).to eql('ulyz')
    end

    it 'is frozen by default' do
      expect(Settings.new).to be_frozen
    end
  end
end
