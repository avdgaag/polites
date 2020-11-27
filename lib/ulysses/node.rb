module Ulysses
  class Node
    attr_reader :children

    def initialize(children = [])
      @children = children
    end

    def text
      @children.map(&:text).join
    end

    def eql?(other)
      other.is_a?(self.class) && children.eql?(other.children)
    end
    alias == eql?
  end
end
