require 'ulysses/span'
require 'ulysses/text'

module Ulysses
  RSpec.describe Span do
    it 'considers two blocks with the same content equal' do
      expect(Span.new).to eql(Span.new)
    end

    it 'extracts text value from its children' do
      expect(Span::Strong.new([]).text).to be_empty
      expect(Span::Strong.new([Text.new('hello')]).text).to eql('hello')
    end

    describe '.build' do
      it 'builds a Strong' do
        expect(Span.build([], kind: 'strong')).to eql(Span::Strong.new)
      end

      it 'builds a Emph' do
        expect(Span.build([], kind: 'emph')).to eql(Span::Emph.new)
      end

      it 'builds a Code' do
        expect(Span.build([], kind: 'code')).to eql(Span::Code.new)
      end

      it 'builds a Link' do
        expect(Span.build([], kind: 'link', url: 'bla')).to eql(Span::Link.new([], url: 'bla'))
      end

      it 'builds a Image' do
        expect(Span.build([], kind: 'image', image: 'bla')).to eql(Span::Image.new([], image: 'bla'))
      end

      it 'builds a Annotation' do
        expect(Span.build([], kind: 'annotation', text: 'bla')).to eql(Span::Annotation.new([], 'bla'))
      end

      it 'builds a Footnote' do
        expect(Span.build([], kind: 'footnote', text: 'bla')).to eql(Span::Footnote.new([], 'bla'))
      end

      it 'builds a Delete' do
        expect(Span.build([], kind: 'delete')).to eql(Span::Delete.new)
      end

      it 'builds a Mark' do
        expect(Span.build([], kind: 'mark')).to eql(Span::Mark.new)
      end
    end
  end
end
