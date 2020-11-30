# frozen_string_literal: true

require 'stringio'
require 'polites/cli'

module Polites
  RSpec.describe Cli do
    let(:stdout) { StringIO.new }
    let(:stdin) { StringIO.new }
    let(:cli) { Cli.new(stdin: stdin, stdout: stdout) }

    it 'prints the version number' do
      cli.call(['-v'])
      expect(stdout.string).to match(/\d+.\d+.\d+\n/)
    end

    it 'prints the help options details' do
      cli.call(['-h'])
      expect(stdout.string).to match(/Usage: polites/)
    end

    it 'converts a single file' do
      cli.call(
        [
          'spec/fixtures/How to live with purpose using goals and tasks!.ulyz'
        ]
      )
      expect(stdout.string).not_to be_empty
    end

    it 'converts a multiple files' do
      cli.call(
        [
          'spec/fixtures/How to live with purpose using goals and tasks!.ulyz',
          'spec/fixtures/How to live with purpose using goals and tasks!.ulyz'
        ]
      )
      expect(stdout.string).not_to be_empty
    end
  end
end
