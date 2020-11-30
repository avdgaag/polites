# frozen_string_literal: true

module Polites
  # The Node is the basic building block of the AST we parse Polites document
  # contents into.
  class Node
    # @return [Array<Node>]
    attr_reader :children

    # @param [Array<Node>] children
    def initialize(children = [])
      @children = children
    end

    # Assemble the text contents of this node and all its children combined.
    #
    # @return [String]
    def text
      @children.map(&:text).join
    end

    def eql?(other)
      other.is_a?(self.class) && children.eql?(other.children)
    end

    alias == eql?
  end
end
