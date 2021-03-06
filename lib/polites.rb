# frozen_string_literal: true

require 'polites/version'

# Polites allows you to work with files generated by the
# [Ulysses](https://ulysses.app) writing application for macos.
#
# Most importantly, this gem allows you to take Ulysses .ulyz files as input and
# transform them into HTML, all from Ruby. Additionally, you can extract
# embedded media files from the .ulyz file.
#
# @example Transform a file to HTML
#   Polites::Convert.new.call('/path/to/file.ulyz')
#   # => (html content)
# @example Parse a sheet
#   Polites::File.open('/path/to/file.ulyz') do |f|
#     sheet = Polites::Parser.new.parse_sheet(f.content)
#     sheet.keywords # => ['Keyword1', 'Keyword2']
#     sheet.files # => ['1a3577ba004942ecb71d8a940cab4b1f']
#     Polites::HtmlFormatter.new.call(sheet)
#     # => (html content)
#   end
module Polites
  # Generic error all Polites-specific errors inherit from.
  class Error < StandardError; end

  # Raised when encountering an error during parsing of source files.
  class ParseError < Error; end

  # Raised when encountering an error during the formatting of our internal AST
  # into some target output.
  class FormattingError < Error; end
end
