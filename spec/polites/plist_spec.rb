# frozen_string_literal: true

require 'polites/plist'

module Polites
  RSpec.describe Plist do
    it 'reads a binary plist file as JSON' do
      skip 'Not supported on CI' if ENV['CI']
      plist = Plist.new('spec/fixtures/.Ulysses-Group.plist')
      expect(plist.to_h).to include('sheetClusters' => [])
    end
  end
end
