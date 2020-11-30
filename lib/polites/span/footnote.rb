# frozen_string_literal: true

require_relative '../span'

module Polites
  class Span::Footnote < Span
    attr_reader :text

    def initialize(children, text)
      super(children)
      @text = text
    end

    def eql?(other)
      super && text == other.text
    end
  end
end
