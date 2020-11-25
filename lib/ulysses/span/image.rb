require_relative '../span'

module Ulysses
  class Span::Image < Span
    attr_reader :children, :image, :filename, :title, :description, :width, :height

    def initialize(children, image:, filename: nil, title: nil, description: nil, width: nil, height: nil)
      super(children)
      @image = image
      @filename = filename
      @title = title
      @description = description
      @width = width
      @height = height
    end

    def eql?(other)
      super &&
        image == other.image &&
        filename == other.filename &&
        title == other.title &&
        description == other.description &&
        width == other.width &&
        height == other.height
    end
  end
end
