require 'ulysses/block'

module Ulysses
  RSpec.describe Block do
    it 'considers two blocks with the same content equal' do
      expect(Block.new).to eql(Block.new)
    end

    it 'extracts text value from its children' do
      expect(Block::Paragraph.new([]).text).to be_empty
      expect(Block::Paragraph.new([Text.new('hello')]).text).to eql('hello')
    end

    describe '.build' do
      it 'builds a Heading1' do
        expect(Block.build([], kind: 'heading1')).to eql(Block::Heading1.new)
      end

      it 'builds a Heading2' do
        expect(Block.build([], kind: 'heading2')).to eql(Block::Heading2.new)
      end

      it 'builds a Heading3' do
        expect(Block.build([], kind: 'heading3')).to eql(Block::Heading3.new)
      end

      it 'builds a Heading4' do
        expect(Block.build([], kind: 'heading4')).to eql(Block::Heading4.new)
      end

      it 'builds a Heading5' do
        expect(Block.build([], kind: 'heading5')).to eql(Block::Heading5.new)
      end

      it 'builds a Heading6' do
        expect(Block.build([], kind: 'heading6')).to eql(Block::Heading6.new)
      end

      it 'builds a Paragraph' do
        expect(Block.build([], kind: 'paragraph')).to eql(Block::Paragraph.new)
      end

      it 'builds a Blockquote' do
        expect(Block.build([], kind: 'blockquote')).to eql(Block::Blockquote.new)
      end

      it 'builds a CodeBlock' do
        expect(Block.build([], kind: 'codeblock', syntax: 'css')).to eql(Block::CodeBlock.new([], 'css'))
      end

      it 'builds a Divider' do
        expect(Block.build([], kind: 'divider')).to eql(Block::Divider.new)
      end

      it 'builds a OrderedList' do
        expect(Block.build([], kind: 'orderedList', level: 0)).to eql(Block::OrderedList.new([], 0))
      end

      it 'builds a UnorderedList' do
        expect(Block.build([], kind: 'unorderedList', level: 0)).to eql(Block::UnorderedList.new([], 0))
      end
    end
  end
end
