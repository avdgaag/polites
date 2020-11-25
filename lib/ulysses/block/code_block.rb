require_relative '../block'

module Ulysses
  class Block::CodeBlock < Block
    attr_reader :syntax
    protected :syntax

    def initialize(children, syntax)
      @syntax = syntax
      super(children)
    end

    def eql?(other)
      super && syntax == other.syntax
    end
  end
end
