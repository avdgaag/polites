# frozen_string_literal: true

module Ulysses
  class Markup
    attr_reader :version, :identifier, :display_name, :tags

    def initialize(version, identifier, display_name, tags = [])
      @version = version
      @identifier = identifier
      @display_name = display_name
      @tags = tags
    end
  end
end
