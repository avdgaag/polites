# frozen_string_literal: true

module Polites
  # Modify the AST for a parsed sheet to group list items in a nested structure,
  # rather than a flat structure using levels.
  class ListIndenter
    List = Struct.new(:children)

    # @param [Array<Polites::Node>] items
    # @return [Array<Polites::Node>]
    def call(items)
      items
        .chunk { |i| i.is_a?(Block::List) }.to_a
        .inject([]) do |acc, (k, contents)|
        acc + (k ? [List.new(indent(contents))] : contents)
      end
    end

    private

    def indent(items)
      items
        .chunk { |item| item.level > items.first.level }
        .inject([]) do |acc, (indented, subitems)|
        if indented
          acc.last.children << List.new(indent(subitems))
          acc
        else
          acc + subitems
        end
      end
    end
  end
end
