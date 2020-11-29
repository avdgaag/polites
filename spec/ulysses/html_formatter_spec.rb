# frozen_string_literal: true

require 'ulysses/html_formatter'

module Ulysses
  RSpec.describe HtmlFormatter do
    let(:html_formatter) { HtmlFormatter.new }

    describe 'for sheets' do
      it 'includes footnotes at the end' do
        content = Sheet.new(
          version: '1',
          app_version: '2',
          markup: 'markup',
          content: [
            Block::Paragraph.new([Text.new('hello '), Span::Footnote.new([], Text.new('bla'))])
          ]
        )
        expect(html_formatter.call(content)).to eql(<<~STR)
          <p>hello <sup><a id="ffn1" href="#fn1" class="footnote">1</a></sup></p>
          <ol id="footnotes">
            <li id="fn1">bla</li>
          </ol>
        STR
      end
    end

    describe 'for fragments' do
      it 'formats two paragraphs as <p> <p>' do
        content = [
          Block::Paragraph.new([Text.new('text1')]),
          Block::Paragraph.new([Text.new('text2')])
        ]
        expect(html_formatter.call(content)).to eql('<p>text1</p><p>text2</p>')
      end

      it 'formats nested content' do
        content = [
          Block::Paragraph.new([Span::Strong.new([Text.new('text1')]), Text.new(' text2')])
        ]
        expect(html_formatter.call(content)).to eql('<p><strong>text1</strong> text2</p>')
      end

      it 'combines multiple consecutive ordered list items in a single <ol>' do
        content = [
          Block::Paragraph.new([Text.new('text')]),
          Block::OrderedList.new([Text.new('text1')], 0),
          Block::OrderedList.new([Text.new('text2')], 1),
          Block::OrderedList.new([Text.new('text3')], 2),
          Block::OrderedList.new([Text.new('text4')], 1),
          Block::OrderedList.new([Text.new('text5')], 0),
          Block::Paragraph.new([Text.new('text')])
        ]
        expect(html_formatter.call(content, indent: true, join: "\n")).to eql(<<~STR.chomp)
          <p>text</p>
          <ol>
          <li>text1
          <ol>
          <li>text2
          <ol>
          <li>text3</li>
          </ol>
          </li>
          <li>text4</li>
          </ol>
          </li>
          <li>text5</li>
          </ol>
          <p>text</p>
        STR
      end
    end

    describe 'for blocks' do
      it 'formats text as plain text' do
        content = Text.new('text')
        expect(html_formatter.call(content)).to eql('text')
      end

      it 'formats a heading as <h1>' do
        content = Block::Heading1.new([Text.new('text')])
        expect(html_formatter.call(content)).to eql('<h1>text</h1>')
      end

      it 'formats a heading as <h2>' do
        content = Block::Heading2.new([Text.new('text')])
        expect(html_formatter.call(content)).to eql('<h2>text</h2>')
      end

      it 'formats a heading as <h3>' do
        content = Block::Heading3.new([Text.new('text')])
        expect(html_formatter.call(content)).to eql('<h3>text</h3>')
      end

      it 'formats a heading as <h4>' do
        content = Block::Heading4.new([Text.new('text')])
        expect(html_formatter.call(content)).to eql('<h4>text</h4>')
      end

      it 'formats a heading as <h5>' do
        content = Block::Heading5.new([Text.new('text')])
        expect(html_formatter.call(content)).to eql('<h5>text</h5>')
      end

      it 'formats a heading as <h6>' do
        content = Block::Heading6.new([Text.new('text')])
        expect(html_formatter.call(content)).to eql('<h6>text</h6>')
      end

      it 'formats a paragraph as <p>' do
        content = Block::Paragraph.new([Text.new('text')])
        expect(html_formatter.call(content)).to eql('<p>text</p>')
      end

      it 'formats a blockquote as a <blockquote><p>' do
        content = Block::Blockquote.new([Text.new('text')])
        expect(html_formatter.call(content)).to eql('<blockquote><p>text</p></blockquote>')
      end

      it 'formats a divider as <hr>' do
        content = Block::Divider.new([])
        expect(html_formatter.call(content)).to eql('<hr>')
      end

      it 'formats a code block as <pre><code>' do
        content = Block::CodeBlock.new([Text.new('text')], 'css')
        expect(html_formatter.call(content)).to eql('<pre><code class="language-css">text</code></pre>')
      end

      it 'formats an unordered list as <li>' do
        content = Block::UnorderedList.new([Text.new('text')], 0)
        expect(html_formatter.call(content)).to eql('<li>text</li>')
      end

      it 'formats an ordered list as <li>' do
        content = Block::OrderedList.new([Text.new('text')], 0)
        expect(html_formatter.call(content)).to eql('<li>text</li>')
      end
    end

    describe 'for spans' do
      it 'formats a strong as <strong>' do
        content = Span::Strong.new([Text.new('text')])
        expect(html_formatter.call(content)).to eql('<strong>text</strong>')
      end

      it 'formats a emph as <em>' do
        content = Span::Emph.new([Text.new('text')])
        expect(html_formatter.call(content)).to eql('<em>text</em>')
      end

      it 'formats a mark as <mark>' do
        content = Span::Mark.new([Text.new('text')])
        expect(html_formatter.call(content)).to eql('<mark>text</mark>')
      end

      it 'formats a delete as <del>' do
        content = Span::Delete.new([Text.new('text')])
        expect(html_formatter.call(content)).to eql('<del>text</del>')
      end

      it 'formats a code as <code>' do
        content = Span::Code.new([Text.new('text')])
        expect(html_formatter.call(content)).to eql('<code>text</code>')
      end

      it 'formats a link as <a>' do
        content = Span::Link.new([Text.new('text')], url: 'http://example.com', title: 'my title')
        expect(html_formatter.call(content)).to eql('<a href="http://example.com" title="my title">text</a>')

        content = Span::Link.new([Text.new('text')], url: 'http://example.com')
        expect(html_formatter.call(content)).to eql('<a href="http://example.com">text</a>')
      end

      it 'formats an annotation as plain text' do
        content = Span::Annotation.new([Text.new('text')], text: 'bla')
        expect(html_formatter.call(content)).to eql('text')
      end

      it 'formats a footnote as a <sup><a>' do
        content = Span::Footnote.new([], 'bla')
        expect(html_formatter.call(content)).to eql('<sup><a id="ffn1" href="#fn1" class="footnote">1</a></sup>')
        expect(html_formatter.call(content)).to eql('<sup><a id="ffn2" href="#fn2" class="footnote">2</a></sup>')
      end

      it 'formats an image as <figure><img>' do
        content = Span::Image.new([], image: 'bla')
        expect(html_formatter.call(content)).to eql('<figure><img src="bla"></figure>')
      end

      it 'formats an image with dimensions as <figure><img width height>' do
        content = Span::Image.new([], image: 'bla', width: 200, height: 100)
        expect(html_formatter.call(content)).to eql('<figure><img src="bla" width="200" height="100"></figure>')
      end

      it 'formats an image with a description as <figure><img><figcaption>' do
        content = Span::Image.new([], image: 'bla', description: 'foo')
        expect(html_formatter.call(content)).to eql('<figure><img src="bla" alt="foo"><figcaption>foo</figcaption></figure>')
      end

      it 'formats an image with a filename as <figure><img>' do
        content = Span::Image.new([], image: 'bla', filename: 'foo')
        expect(html_formatter.call(content)).to eql('<figure><img src="foo"></figure>')
      end

      it 'formats an image with a title as <figure><img title>' do
        content = Span::Image.new([], image: 'bla', title: 'foo')
        expect(html_formatter.call(content)).to eql('<figure><img src="bla" title="foo"></figure>')
      end
    end
  end
end
