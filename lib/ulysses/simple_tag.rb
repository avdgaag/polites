require_relative './tag'

module Ulysses
  class SimpleTag < Tag
    attr_reader :pattern

    def initialize(name, pattern)
      super(name)
      @pattern = pattern
    end

    def eql?(other)
      super && pattern == other.pattern
    end
  end
end
