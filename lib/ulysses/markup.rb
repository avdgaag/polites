# frozen_string_literal: true

module Ulysses
  # The markup section defines the markup used in a Ulysses document, specifying
  # both its versions and patterns defined in {Tag}s.
  class Markup
    # @return [String]
    attr_reader :version

    # @return [String]
    attr_reader :identifier

    # @return [String]
    attr_reader :display_name

    # @return [Array<Tag>]
    attr_reader :tags

    # @param [String] version
    # @param [String] identifier
    # @param [String] display_name
    # @param [Array<Tag>] tags
    def initialize(version, identifier, display_name, tags = [])
      @version = version
      @identifier = identifier
      @display_name = display_name
      @tags = tags
      freeze
    end
  end
end
