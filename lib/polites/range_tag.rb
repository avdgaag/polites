# frozen_string_literal: true

require_relative './tag'

module Polites
  # A range tag is a {Tag} defined by a start and an end pattern, such as used
  # by defining bold formatting.
  class RangeTag < Tag
    # @return [String]
    attr_reader :start_pattern
    # @return [String]
    attr_reader :end_pattern

    # @param [String] name
    # @param [String] start_pattern
    # @param [String] end_pattern
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
