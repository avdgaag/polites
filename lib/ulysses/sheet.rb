# frozen_string_literal: true

module Ulysses
  # A sheet is represents a single "document" in Ulysses. It composes the main
  # content in {Sheet#content}, its markup definition in {Sheet#markup}, any
  # attaches files in {Sheet#files} and some metadata.
  class Sheet
    # @return [String]
    attr_reader :version

    # @return [String]
    attr_reader :app_version

    # @return [Markup]
    attr_reader :markup

    # @return [Array<Node>]
    attr_reader :content

    # @return [Array<String>]
    attr_reader :keywords

    # @return [Array<String>]
    attr_reader :files

    # @return [Array<Array<Node>>]
    attr_reader :notes

    # @param [String] version
    # @param [String] app_version
    # @param [Markup] markup
    # @param [Array<Node>] content
    # @param [Array<String>] keywords
    # @param [Array<String>] files
    # @param [Array<Array<Node>>] notes
    def initialize(version:, app_version:, markup:, content:, keywords: [], files: [], notes: [])
      @version = version
      @app_version = app_version
      @markup = markup
      @content = content
      @keywords = keywords
      @files = files
      @notes = notes
    end

    # Get all files that were referenced in the content, such as inline images.
    #
    # @return [Array<Span::Image>]
    def inline_files
      content.flat_map do |node|
        node.children.grep(Span::Image)
      end
    end

    # Get all files that were attached to the sheet without explicit mention in
    # the content.
    #
    # @return [Array<String>]
    def attached_files
      files - inline_files.map(&:image)
    end
  end
end
