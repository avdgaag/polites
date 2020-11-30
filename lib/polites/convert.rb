# frozen_string_literal: true

require_relative './parser'
require_relative './html_formatter'
require_relative './file'

module Polites
  # Convert a Polites file to another format.
  class Convert
    # @param [Polites::Parser] parser
    # @param [Polites::HtmlFormatter] formatter
    def initialize(parser: Polites::Parser.new, formatter: Polites::HtmlFormatter.new)
      @parser = parser
      @formatter = formatter
    end

    # Convert the contents of `filename` to HTML and return the result as a String.
    #
    # @param [#to_s, #to_path] filename
    # @return [String]
    def call(filename)
      File.open(filename) do |f|
        f.content
         .then { |c| @parser.parse_sheet(c) }
         .then { |c| @formatter.call(c) }
      end
    end
  end
end
