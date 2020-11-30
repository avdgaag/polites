# frozen_string_literal: true

require_relative './tag'

module Ulysses
  # A simple tag is a {Tag} defined by a single pattern, such as for headings.
  class SimpleTag < Tag
    # @return [String]
    attr_reader :pattern

    # @param [String] name
    # @param [String] pattern
    def initialize(name, pattern)
      super(name)
      @pattern = pattern
    end

    def eql?(other)
      super && pattern == other.pattern
    end
  end
end
