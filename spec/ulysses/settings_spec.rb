require 'ulysses/settings'

module Ulysses
  RSpec.describe Settings do
    it 'combines plist files from a directory' do
      settings = Settings.from_directory('spec/fixtures')
      expect(settings['defaultPathExtensions']).to eql('ulyz')
    end

    it 'is frozen by default' do
      settings = Settings.from_directory('spec/fixtures')
      expect(settings).to be_frozen
    end
  end
end
