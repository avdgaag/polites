require_relative './parser'
require_relative './html_formatter'
require_relative './file'

module Ulysses
  class Convert
    def initialize(parser: Ulysses::Parser.new, formatter: Ulysses::HtmlFormatter.new)
      @parser = parser
      @formatter = formatter
    end

    def call(filename)
      filename
        .then { |f| File.new(f) }
        .then { |f| @parser.parse_sheet(f.content) }
        .then { |f| @formatter.call(f) }
    end
  end
end
