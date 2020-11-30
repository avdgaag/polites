# frozen_string_literal: true

module Ulysses
  # A tag is used to define the markup used in Ulysses documents.
  class Tag
    # @return [String]
    attr_reader :name

    # @param [String] name
    def initialize(name)
      @name = name
    end

    def eql?(other)
      other.is_a?(self.class) && name == other.name
    end

    alias == eql?
  end
end
