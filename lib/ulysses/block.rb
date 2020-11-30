# frozen_string_literal: true

require_relative '../ulysses'
require_relative './node'

module Ulysses
  # A block represents a structural element in a Ulysses document, mapping to
  # block-level elements in HTML. Examples include paragraphs and headings.
  #
  # Blocks may technically  contain other blocks, as well as {Text} and {Span}
  # elements.
  class Block < Node
    # Build the proper kind of span from the given arguments.
    #
    # @param [Array<Node>] children
    # @param [String] kind the type Ulysses has given to this node.
    # @param [Fixnum] level the indentation level used by list items.
    # @param [String] syntax the syntax attribute used in code blocks.
    # @raise [ParseError] when encountering unexpected `kind`
    # @return [Span]
    def self.build(children = [], kind: 'paragraph', level: 0, syntax: nil)
      case kind
      when 'heading1'
        Heading1.new(children)
      when 'heading2'
        Heading2.new(children)
      when 'heading3'
        Heading3.new(children)
      when 'heading4'
        Heading4.new(children)
      when 'heading5'
        Heading5.new(children)
      when 'heading6'
        Heading6.new(children)
      when 'paragraph'
        Paragraph.new(children)
      when 'unorderedList'
        UnorderedList.new(children, level)
      when 'orderedList'
        OrderedList.new(children, level)
      when 'blockquote'
        Blockquote.new(children)
      when 'divider'
        Divider.new(children)
      when 'codeblock'
        CodeBlock.new(children, syntax)
      else
        raise ParseError, "unknown block type #{kind.inspect}"
      end
    end
  end
end

require_relative './block/heading1'
require_relative './block/heading2'
require_relative './block/heading3'
require_relative './block/heading4'
require_relative './block/heading5'
require_relative './block/heading6'
require_relative './block/paragraph'
require_relative './block/ordered_list'
require_relative './block/unordered_list'
require_relative './block/blockquote'
require_relative './block/divider'
require_relative './block/code_block'
