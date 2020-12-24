# frozen_string_literal: true

module Polites
  # Take a list of items and collapse a collection of subsequent code blocks
  # into a single one separated by newlines.
  class CodeGrouper
    # @param [Array<Polites::Node>] items
    # @return [Array<Polites::Node>]
    def call(items)
      items
        .chunk { |i| i.is_a?(Block::CodeBlock) }.to_a
        .inject([]) do |acc, (k, contents)|
        acc + (k ? [combine(contents)] : contents)
      end
    end

    private

    def combine(items)
      Block::CodeBlock.new(
        items
          .inject([]) { |acc, item| acc + item.children + [Text.new("\n")] }
          .slice(0..-2),
        items.first.syntax
      )
    end
  end
end
