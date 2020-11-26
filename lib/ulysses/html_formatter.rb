require_relative './block'
require_relative './span'
require_relative './text'
require_relative './sheet'

module Ulysses
  class ListIndenter
    List = Struct.new(:children)

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

  class HtmlFormatter
    def initialize
      @footnotes = []
      @indenter = ListIndenter.new
    end

    def footnotes
      @footnotes.each_with_index.map { |obj, i| %(  <li id="fn#{i + 1}">#{call(obj)}</li>) }.join("\n")
    end

    def call(obj)
      case obj
      when Sheet
        call(obj.content) + %(\n<ol id="footnotes">\n) + footnotes + "\n</ol>\n"
      when ListIndenter::List
        nl = obj.children.first.level > 0 ? "\n" : ''
        tag =
          case obj.children.first
          when Block::OrderedList then 'ol'
          when Block::UnorderedList then 'ul'
          end
        "#{nl}<#{tag}>\n" + obj.children.map { |o| call(o) }.join("\n") + "\n</#{tag}>#{nl}"
      when Array
        @indenter.call(obj).map { |o| call(o) }.join("\n")
      when Block::UnorderedList
        '<li>' + obj.children.map { |c| call(c) }.join + '</li>'
      when Block::OrderedList
        '<li>' + obj.children.map { |c| call(c) }.join + '</li>'
      when Block::Paragraph
        '<p>' + obj.children.map { |c| call(c) }.join + '</p>'
      when Block::Heading1
        '<h1>' + obj.children.map { |c| call(c) }.join + '</h1>'
      when Block::Heading2
        '<h2>' + obj.children.map { |c| call(c) }.join + '</h2>'
      when Block::Heading3
        '<h3>' + obj.children.map { |c| call(c) }.join + '</h3>'
      when Block::Heading4
        '<h4>' + obj.children.map { |c| call(c) }.join + '</h4>'
      when Block::Heading5
        '<h5>' + obj.children.map { |c| call(c) }.join + '</h5>'
      when Block::Heading6
        '<h6>' + obj.children.map { |c| call(c) }.join + '</h6>'
      when Block::Blockquote
        '<blockquote><p>' + obj.children.map { |c| call(c) }.join + '</p></blockquote>'
      when Block::CodeBlock
        '<pre><code class="language-' + obj.syntax + '">' + obj.children.map { |c| call(c) }.join + '</code></pre>'
      when Block::Divider
        '<hr>'
      when Span::Strong
        '<strong>' + obj.children.map { |c| call(c) }.join + '</strong>'
      when Span::Emph
        '<em>' + obj.children.map { |c| call(c) }.join + '</em>'
      when Span::Delete
        '<del>' + obj.children.map { |c| call(c) }.join + '</del>'
      when Span::Mark
        '<mark>' + obj.children.map { |c| call(c) }.join + '</mark>'
      when Span::Code
        '<code>' + obj.children.map { |c| call(c) }.join + '</code>'
      when Span::Annotation
        obj.children.map { |c| call(c) }.join
      when Span::Footnote
        @footnotes << obj.text
        n = @footnotes.count
        %(<sup><a id="ffn#{n}" href="#fn#{n}" class="footnote">#{n}</a></sup>)
      when Span::Image
        figcaption = ''
        dimensions = ''
        alt = ''
        title = ''
        if obj.description
          alt = %( alt="#{obj.description}")
          figcaption = '<figcaption>' + obj.description + '</figcaption>'
        end
        dimensions << %( width="#{obj.width}") if obj.width
        dimensions << %( height="#{obj.height}") if obj.height
        title << %( title="#{obj.title}") if obj.title
        %(<figure><img src="#{obj.filename || obj.image}"#{title}#{alt}#{dimensions}>#{figcaption}</figure>)
      when Span::Link
        if obj.title
          '<a href="' + obj.url + '" title="' + obj.title + '">' + obj.children.map { |c| call(c) }.join + '</a>'
        else
          '<a href="' + obj.url + '">' + obj.children.map { |c| call(c) }.join + '</a>'
        end

      when Text
        obj.text
      else
        raise "Unknown obj #{obj.inspect}"
      end
    end
  end
end
