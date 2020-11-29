# frozen_string_literal: true

require 'spec_helper'
require 'ulysses/text'

module Ulysses
  RSpec.describe Text do
    it 'considers two text objects equal' do
      expect(Text.new('a')).to eql(Text.new('a'))
    end
  end
end
