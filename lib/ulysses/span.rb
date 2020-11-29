# frozen_string_literal: true

require_relative './node'

module Ulysses
  class Span < Node
    def self.build(children = [], kind: nil, url: nil, image: nil, filename: nil, title: nil, description: nil, width: nil, height: nil, text: nil)
      case kind
      when 'link'
        Span::Link.new(children, url: url, title: title)
      when 'mark'
        Span::Mark.new(children)
      when 'emph'
        Span::Emph.new(children)
      when 'strong'
        Span::Strong.new(children)
      when 'annotation'
        Span::Annotation.new(children, text)
      when 'footnote'
        Span::Footnote.new(children, text)
      when 'delete'
        Span::Delete.new(children)
      when 'code'
        Span::Code.new(children)
      when 'image'
        Span::Image.new(children, image: image, filename: filename, title: title, description: description, width: width, height: height)
      else
        raise "unexpected kind #{kind.inspect}"
      end
    end
  end
end

require_relative './span/link'
require_relative './span/emph'
require_relative './span/annotation'
require_relative './span/strong'
require_relative './span/footnote'
require_relative './span/image'
require_relative './span/mark'
require_relative './span/delete'
require_relative './span/code'
