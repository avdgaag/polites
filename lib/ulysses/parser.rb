require 'nokogiri'
require_relative './block'
require_relative './text'
require_relative './span'
require_relative './sheet'
require_relative './markup'
require_relative './simple_tag'
require_relative './range_tag'

module Ulysses
  class Parser
    def initialize
      reset
    end

    def parse_sheet(source)
      sheet = Nokogiri(source).xpath('/sheet').first
      Sheet.new(
        version: sheet[:version],
        app_version: sheet[:app_version],
        markup: parse_markup(sheet),
        content: parse_fragment(sheet),
        keywords: parse_keywords(sheet),
        files: parse_files(sheet),
        notes: parse_notes(sheet)
      )
    end

    def parse_markup(element)
      markup = element.xpath('markup').first
      tags = markup.xpath('tag').map do |e|
        if e[:pattern]
          SimpleTag.new(e[:definition], e[:pattern])
        elsif e[:startPattern] && e[:endPattern]
          RangeTag.new(e[:definition], e[:startPattern], e[:endPattern])
        end
      end
      Markup.new(markup[:version], markup[:identifier], markup[:displayName], tags)
    end

    def parse_fragment(source)
      element =
        case source
        when Nokogiri::XML::Element
          source
        when String
          Nokogiri(source)
        end
      element.xpath('string/p').map do |el|
        parse(el)
      end
    end

    def parse(source)
      case source
      when Nokogiri::XML::Element
        parse_element(source)
      when Nokogiri::XML::NodeSet
        source.map { |s| parse(s) }.compact
      when Nokogiri::XML::Text
        Text.new(source.text)
      when String
        doc = Nokogiri(source)
        if doc.children.any?
          parse(doc.children)
        else
          Text.new(source)
        end
      else
        raise "unexpected #{source.inspect}"
      end
    end

    private

    def parse_element(source)
      case source.name
      when 'p'
        block = Block.build(parse(source.children), **@current_block_attributes)
        reset_block
        block
      when 'element'
        span = Span.build(
          parse(source.children),
          kind: source[:kind],
          **@current_span_attributes
        )
        reset_span
        span
      when 'tag'
        @current_block_attributes[:kind] = source[:kind] if source[:kind]
        @current_block_attributes[:level] += 1 if source.text == "\t"
        nil
      when 'attribute'
        case source[:identifier]
        when 'syntax'
          @current_block_attributes[:syntax] = source.text
        when 'text'
          @current_span_attributes[:text] = parse_fragment(source)
        when 'size'
          parse(source.children)
        else
          @current_span_attributes[source[:identifier].downcase.to_sym] = source.text
        end
        nil
      when 'size'
        @current_span_attributes[:width] = source[:width].to_i
        @current_span_attributes[:height] = source[:height].to_i
        nil
      when 'tags'
        parse(source.children)
        nil
      else
        raise "unknown element name #{source.name}"
      end
    end

    def parse_keywords(element)
      element
        .xpath('./attachment[@type="keywords"]')
        .flat_map { |el| el.text.split(',') }
    end

    def parse_files(element)
      element
        .xpath('./attachment[@type="file"]')
        .map { |el| el.text }
    end

    def parse_notes(element)
      element
        .xpath('./attachment[@type="note"]')
        .map { |el| parse_fragment(el) }
    end

    def reset
      reset_block
      reset_span
    end

    def reset_block
      @current_block_attributes = { kind: 'paragraph', level: 0 }
    end

    def reset_span
      @current_span_attributes = {}
    end
  end
end
