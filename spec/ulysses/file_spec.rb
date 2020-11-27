require_relative '../../lib/ulysses/file'

module Ulysses
  RSpec.describe File do
    it 'requires pathname as a path' do
      expect { File.new(nil) }.to raise_error(TypeError)
      expect { File.new(['bla']) }.to raise_error(TypeError)
      expect { File.new(123) }.to raise_error(TypeError)
    end

    it 'raises when reading non-existant file' do
      expect { File.new('bla').content }.to raise_error(Errno::ENOENT)
    end

    it 'reads the content.xml file' do
      expect(File.new('spec/fixtures/How to live with purpose using goals and tasks!.ulyz').content).not_to be_empty
    end
  end
end
