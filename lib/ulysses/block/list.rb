require_relative '../block'

module Ulysses
  class Block::List < Block
    attr_reader :level
    protected :level

    def initialize(children, level)
      super(children)
      @level = level
    end
  end
end
