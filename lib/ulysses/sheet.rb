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

    def title
      @title ||= first_heading&.text
    end

    def drop_title
      content.delete first_heading
    end

    def drop_empty_paragraphs
      content.reject! do |block|
        block.is_a?(Block::Paragraph) && block.children.empty?
      end
    end

    def inline_files
      content.flat_map do |node|
        node.children.grep(Span::Image)
      end
    end

    def attached_files
      files - inline_files.map(&:image)
    end

    private

    def first_heading
      content.find do |block|
        block.is_a?(Block::Heading)
      end
    end
  end
end
