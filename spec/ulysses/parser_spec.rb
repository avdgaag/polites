require 'ulysses/parser'

module Ulysses
  RSpec.describe Parser do
    before(:all) do
      @content = File.read('spec/fixtures/content.xml')
    end

    let(:content) { @content }

    describe '#parse_sheet' do
      let(:sheet) { subject.parse_sheet(content) }

      it 'parses the sheet version' do
        expect(sheet.version).to eql('6')
      end

      it 'parses the app version' do
        expect(sheet.app_version).to eql('21.1')
      end

      it 'parses the markup configuration' do
        expect(sheet.markup).to be_kind_of(Markup)
      end

      it 'parses the content fragment' do
        expect(sheet.content).to include(Block.new([Text.new('How to live with purpose using goals and tasks!')]))
      end

      it 'parses keyword attachments' do
        expect(sheet.keywords).to eql(%w[GTD Stoicism])
      end

      it 'parses file attachments' do
        expect(sheet.files).to eql(%w[1a3577ba004942ecb71d8a940cab4b1f 5d3baf430fd948a9bbcaad5843ce2132])
      end

      it 'parses notes' do
        expect(sheet.notes.size).to be(1)
      end
    end

    describe 'parse_markup' do
      let(:markup) { subject.parse_markup(Nokogiri(content).xpath('/sheet').first) }

      it 'parses the markup version' do
        expect(markup.version).to eql('1')
      end

      it 'parses the identifier' do
        expect(markup.identifier).to eql('markdownxl')
      end

      it 'parses the display name' do
        expect(markup.display_name).to eql('Markdown XL')
      end

      it 'parses tag definitions' do
        expect(markup.tags).to include(SimpleTag.new('heading1', '#'))
        expect(markup.tags).to include(RangeTag.new('code', '`', '`'))
      end
    end

    describe '#parse_fragment' do
      it 'parses two empty paragraphs to two empty blocks' do
        expect(subject.parse_fragment('<string><p></p><p></p></string>')).to eql([Block::Paragraph.new, Block::Paragraph.new])
      end
    end

    describe '#parse' do
      it 'parses text as a text object' do
        expect(subject.parse('hello')).to eql(Text.new('hello'))
      end

      it 'parses an empty paragraph to an empty block' do
        expect(subject.parse('<p></p>')).to eql([Block::Paragraph.new])
      end

      it 'parses a paragraph with text to a block with a text node' do
        expect(subject.parse('<p>hello</p>')).to eql([Block::Paragraph.new([Text.new('hello')])])
      end

      it 'parses nested tags into span with text nodes' do
        expect(subject.parse('<p><element kind="strong">Hello</element></p>'))
          .to eql([Block::Paragraph.new([Span::Strong.new([Text.new('Hello')])])])
      end

      it 'parses tags into block attributes' do
        expect(subject.parse('<p><tags><tag kind="heading2">## </tag></tags>Hello</p>'))
          .to eql([Block::Heading2.new([Text.new('Hello')])])
        expect(subject.parse('<p><tags><tag kind="orderedList">1. </tag></tags>Hello</p>'))
          .to eql([Block::OrderedList.new([Text.new('Hello')], 0)])
        expect(subject.parse('<p><tags><tag kind="unorderedList">1. </tag></tags>Hello</p>'))
          .to eql([Block::UnorderedList.new([Text.new('Hello')], 0)])
      end

      it 'increments level for each tab tag' do
        expect(subject.parse('<p><tags><tag>	</tag><tag kind="unorderedList">1. </tag></tags>Hello</p>'))
          .to eql([Block::UnorderedList.new([Text.new('Hello')], 1)])
        expect(subject.parse('<p><tags><tag>	</tag><tag>	</tag><tag kind="unorderedList">1. </tag></tags>Hello</p>'))
          .to eql([Block::UnorderedList.new([Text.new('Hello')], 2)])
      end

      it 'parses element attributes' do
        expect(subject.parse('<p><element kind="link"><attribute identifier="URL">http://example.com</attribute>Hello</element></p>'))
          .to eql([Block::Paragraph.new([Span::Link.new([Text.new('Hello')], url: 'http://example.com')])])
        image_block = <<~STR
          <p><element kind="image"><attribute identifier="image">a661ad9286514e1195b8c277fa1ea5c7</attribute><attribute identifier="filename">explicit-filename.png</attribute><attribute identifier="title">Image title</attribute><attribute identifier="description">A recurring checklist task in Things.</attribute><attribute identifier="size"><size width="300" height="200"></size></attribute></element></p>
        STR
        expect(subject.parse(image_block))
          .to eql([Block::Paragraph.new([Span::Image.new([], image: 'a661ad9286514e1195b8c277fa1ea5c7', filename: 'explicit-filename.png', title: 'Image title', description: 'A recurring checklist task in Things.', width: 300, height: 200)])])
      end

      it 'parses annotation to a fragment attribute' do
        annotation = <<~STR
          <p><element kind="annotation"><attribute identifier="text"><string xml:space="preserve">
          <p>Here is an annotation</p>
          </string></attribute>align these two</element></p>
        STR
        expect(subject.parse(annotation))
          .to eql([Block::Paragraph.new([Span::Annotation.new([Text.new('align these two')], [Block::Paragraph.new([Text.new('Here is an annotation')])])])])
      end
    end
  end
end
