# frozen_string_literal: true

require_relative '../../lib/polites/file'

module Polites
  RSpec.describe File do
    it 'requires pathname as a path' do
      expect { File.new(nil) }.to raise_error(TypeError)
      expect { File.new(['bla']) }.to raise_error(TypeError)
      expect { File.new(123) }.to raise_error(TypeError)
    end

    it 'raises when reading non-existant file' do
      expect { File.open('bla', &:content) }.to raise_error(Errno::ENOENT)
    end

    it 'reads the content.xml file' do
      expect(File.open('spec/fixtures/How to live with purpose using goals and tasks!.ulyz', &:content)).not_to be_empty
    end

    context '#media' do
      let(:file) { File.new('spec/fixtures/How to live with purpose using goals and tasks!.ulyz') }

      around do |example|
        file.open
        example.run
        file.close
      end

      it 'gets a zip entry for an ambedded file by fingerprint' do
        expect(file.media('5d3baf430fd948a9bbcaad5843ce2132').name).to eql('How to live with purpose using goals and tasks!.ulysses/Media/Screenshot 2020-01-24 at 09.09.52.5d3baf430fd948a9bbcaad5843ce2132.png')
      end

      it 'returns nil when a file by a fingerprint is not found' do
        expect(file.media('bla')).to be_nil
      end
    end

    context '#extract_to' do
      let(:file) { File.new('spec/fixtures/How to live with purpose using goals and tasks!.ulyz') }
      let(:tmpfile) { @tmpfile }

      around do |example|
        file.open
        Dir.mktmpdir do |dir|
          @tmpfile = ::File.join(dir, 'output')
          example.run
        end
        file.close
      end

      it 'extracts an existing file to the given destination' do
        file.extract_to('How to live with purpose using goals and tasks!.ulysses/Media/Screenshot 2020-01-24 at 09.09.52.5d3baf430fd948a9bbcaad5843ce2132.png', tmpfile)
        expect(::File.size(tmpfile)).to be > 0
      end

      it 'raises when the requested file does not exist' do
        expect { file.extract_to('bla', tmpfile) }.to raise_error(Errno::ENOENT)
      end
    end
  end
end
