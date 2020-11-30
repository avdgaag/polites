# frozen_string_literal: true

require_relative '../ulysses'
require_relative './node'

module Ulysses
  # A span is an element mapping to inline formatting, such as text formatting
  # and images. Spans only exist within blocks and cannot themselves contain
  # {Block} nodes.
  class Span < Node
    # Build the proper kind of span from the given arguments.
    #
    # @param [Array<Node>] children
    # @param [String] kind the type Ulysses has given to this node.
    # @param [String, nil] url the URL attribute for links.
    # @param [String, nil] image the image fingerprint referring to a sheet file.
    # @param [String, nil] filename the explicit filename to use for images.
    # @param [String, nil] title the title attribute for links, images.
    # @param [String, nil] description the description attribute used by images.
    # @param [String, nil] width the explicitly configured image width
    # @param [String, nil] height the explicitly configured image height
    # @param [Array<Node>] text the contents of footnoes and annotation.
    # @raise [ParseError] when encountering unexpected `kind`
    # @return [Span]
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
        raise ParseError, "unexpected kind #{kind.inspect}"
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
