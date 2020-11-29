require 'optparse'
require_relative './convert'
require_relative './version'

module Ulysses
  # Provides the implentation of the command-line interface, exposing functions
  # to be called from a shell or other programs.
  class Cli
    # @param [IO] stdin to read input from
    # @param [IO] stdout to write output to
    # @param [Hash] options default options
    def initialize(stdin:, stdout:, options: {})
      @stdin = stdin
      @stdout = stdout
      @options = options
    end

    # Invoke the program with some options.
    #
    # @param [Array<String>] args arguments given to the program invocation.
    # @return [nil]
    def call(args)
      filenames = option_parser.parse(args, into: @options)
      if @options[:help]
        @stdout.puts option_parser
      elsif @options[:version]
        @stdout.puts Ulysses::VERSION
      elsif filenames.any?
        filenames.each do |filename|
          @stdout.puts Convert.new.call(filename)
        end
      end
      nil
    end

    private

    def option_parser
      @option_parser ||=
        OptionParser.new do |o|
          o.banner = 'Usage: ulysses [options] FILE'
          o.on_tail '-v', '--version', 'Show current version'
          o.on_tail '-h', '--help', 'Show this message'
        end
    end
  end
end
