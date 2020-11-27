require 'ulysses/sheet'
require 'ulysses/block/paragraph'
require 'ulysses/span/strong'
require 'ulysses/text'

module Ulysses
  RSpec.describe Sheet do
    let(:sheet) do
      Sheet.new(
        version: '1',
        app_version: '2',
        markup: 'markup',
        content: content
      )
    end

    context 'when it has no content' do
      let(:content) { [] }

      it 'has no title' do
        expect(sheet.title).to be_nil
      end
    end

    context 'when it has only paragraph content' do
      let(:content) { [Block::Paragraph.new([Text.new('hello')])] }

      it 'does something' do
        expect(sheet.title).to be_nil
      end
    end

    context 'when it has a header in its content' do
      let(:content) { [Block::Heading1.new([Text.new('hello '), Span::Strong.new([Text.new('world!')])])] }

      it 'extracts the text value of the first heading' do
        expect(sheet.title).to eql('hello world!')
      end
    end
  end
end
