# frozen_string_literal: true

require 'ulysses/version'

module Ulysses
  # Generic error all Ulysses-specific errors inherit from.
  class Error < StandardError; end

  # Raised when encountering an error during parsing of source files.
  class ParseError < Error; end

  # Raised when encountering an error during the formatting of our internal AST
  # into some target output.
  class FormattingError < Error; end
end
