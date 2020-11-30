# frozen_string_literal: true

require 'spec_helper'
require 'polites/text'

module Polites
  RSpec.describe Text do
    it 'considers two text objects equal' do
      expect(Text.new('a')).to eql(Text.new('a'))
    end
  end
end
