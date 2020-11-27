require_relative './block'
require_relative './span'
require_relative './text'
require_relative './sheet'
require_relative './list_indenter'

module Ulysses
  class HtmlFormatter
    NL = "\n".freeze

    def initialize
      @footnotes = []
      @indenter = ListIndenter.new
    end

    def call(obj, indent: false, join: '')
      case obj
      when Sheet
        call(obj.content, indent: true, join: NL) +
          NL +
          tag(:ol, NL + footnotes + NL, id: 'footnotes') +
          NL
      when ListIndenter::List
        nl = obj.children.first.level > 0 ? NL : ''
        tag_name =
          case obj.children.first
          when Block::OrderedList then 'ol'
          when Block::UnorderedList then 'ul'
          end
        nl + tag(tag_name, NL + call(obj.children, join: NL) + NL) + nl
      when Array
        coll = indent ? @indenter.call(obj) : obj
        coll.map { |c| call(c) }.join(join)
      when Block::UnorderedList, Block::OrderedList
        tag(:li, call(obj.children))
      when Block::Paragraph
        tag(:p, call(obj.children))
      when Block::Heading1
        tag(:h1, call(obj.children))
      when Block::Heading2
        tag(:h2, call(obj.children))
      when Block::Heading3
        tag(:h3, call(obj.children))
      when Block::Heading4
        tag(:h4, call(obj.children))
      when Block::Heading5
        tag(:h5, call(obj.children))
      when Block::Heading6
        tag(:h6, call(obj.children))
      when Block::Blockquote
        tag(:blockquote, tag(:p, call(obj.children)))
      when Block::CodeBlock
        tag(:pre, tag(:code, call(obj.children), class: "language-#{obj.syntax}"))
      when Block::Divider
        tag(:hr)
      when Span::Strong
        tag(:strong, call(obj.children))
      when Span::Emph
        tag(:em, call(obj.children))
      when Span::Delete
        tag(:del, call(obj.children))
      when Span::Mark
        tag(:mark, call(obj.children))
      when Span::Code
        tag(:code, call(obj.children))
      when Span::Annotation
        call(obj.children)
      when Span::Footnote
        @footnotes << obj.text
        n = @footnotes.count
        tag(:sup, tag(:a, n, id: "ffn#{n}", href: "#fn#{n}", class: 'footnote'))
      when Span::Image
        figcaption = obj.description ? tag(:figcaption, obj.description) : ''
        tag(:figure, tag(:img, nil, src: obj.filename || obj.image, title: obj.title, alt: obj.description, width: obj.width, height: obj.height) + figcaption)
      when Span::Link
        tag(:a, call(obj.children), href: obj.url, title: obj.title)
      when Text
        obj.text
      else
        raise "Unknown obj #{obj.inspect}"
      end
    end

    private

    def footnotes
      @footnotes
        .compact
        .each_with_index
        .map { |obj, i| '  ' + tag(:li, call(obj), id: "fn#{i + 1}") }
        .join(NL)
    end

    def tag(name, content = nil, attributes = {})
      html_attributes = attributes.compact.inject('') do |acc, (key, value)|
        acc + %( #{key}="#{value}")
      end
      case name
      when :hr, :img
        "<#{name}#{html_attributes}>"
      else
        "<#{name}#{html_attributes}>#{content}</#{name}>"
      end
    end
  end
end
