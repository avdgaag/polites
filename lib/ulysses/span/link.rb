# frozen_string_literal: true

require_relative '../span'

module Ulysses
  class Span::Link < Span
    attr_reader :url, :title

    def initialize(children = [], url:, title: nil)
      super(children)
      @url = url
      @title = title
    end

    def eql?(other)
      super &&
        url == other.url &&
        title == other.title
    end
  end
end
