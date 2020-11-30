# frozen_string_literal: true

require 'polites/convert'

module Polites
  RSpec.describe Convert do
    it 'generates HTML from a file' do
      output = Convert.new.call('spec/fixtures/How to live with purpose using goals and tasks!.ulyz')
      expect(output).to match(/How to live/)
    end
  end
end
