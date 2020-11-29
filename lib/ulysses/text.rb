# frozen_string_literal: true

module Ulysses
  class Text
    attr_reader :text

    def initialize(text)
      @text = text
    end

    def eql?(other)
      other.is_a?(self.class) && text == other.text
    end
    alias == eql?
  end
end
