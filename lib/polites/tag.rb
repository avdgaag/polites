# frozen_string_literal: true

module Polites
  # A tag is used to define the markup used in Polites documents.
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
