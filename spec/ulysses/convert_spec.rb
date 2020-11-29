# frozen_string_literal: true

require 'ulysses/convert'

module Ulysses
  RSpec.describe Convert do
    it 'generates HTML from a file' do
      output = Convert.new.call('spec/fixtures/How to live with purpose using goals and tasks!.ulyz')
      expect(output).to match(/How to live/)
    end
  end
end
