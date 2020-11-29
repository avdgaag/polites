module Ulysses
  class Sheet
    attr_reader :version, :app_version, :markup, :content, :keywords, :files, :notes

    def initialize(version:, app_version:, markup:, content:, keywords: [], files: [], notes: [])
      @version = version
      @app_version = app_version
      @markup = markup
      @content = content
      @keywords = keywords
      @files = files
      @notes = notes
    end

    def inline_files
      content.flat_map do |node|
        node.children.grep(Span::Image)
      end
    end

    def attached_files
      files - inline_files.map(&:image)
    end
  end
end
