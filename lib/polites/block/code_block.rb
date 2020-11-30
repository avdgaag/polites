# frozen_string_literal: true

require_relative '../block'

module Polites
  class Block::CodeBlock < Block
    attr_reader :syntax

    def initialize(children, syntax)
      @syntax = syntax
      super(children)
    end

    def eql?(other)
      super && syntax == other.syntax
    end
  end
end
