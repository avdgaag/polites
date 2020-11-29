# frozen_string_literal: true

require_relative '../block'

module Ulysses
  class Block::List < Block
    attr_reader :level

    def initialize(children, level)
      super(children)
      @level = level
    end
  end
end
