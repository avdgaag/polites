# frozen_string_literal: true

module Ulysses
  # A piece of simple text to be output directly. A stand-in for a simple
  # string.
  class Text
    attr_reader :text

    # @param [String] text
    def initialize(text)
      @text = text
    end

    def eql?(other)
      other.is_a?(self.class) && text == other.text
    end

    alias == eql?
  end
end
