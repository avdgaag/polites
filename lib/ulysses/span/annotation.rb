require_relative '../span'

module Ulysses
  class Span::Annotation < Span
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
