# frozen_string_literal: true

require_relative './tag'

module Ulysses
  class RangeTag < Tag
    attr_reader :start_pattern, :end_pattern

    def initialize(name, start_pattern, end_pattern)
      super(name)
      @start_pattern = start_pattern
      @end_pattern = end_pattern
    end

    def eql?(other)
      super &&
        start_pattern == other.start_pattern &&
        end_pattern == other.end_pattern
    end
  end
end
