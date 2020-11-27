require 'optparse'
require_relative './convert'
require_relative './version'

module Ulysses
  class Cli
    def initialize(stdin:, stdout:)
      @stdin = stdin
      @stdout = stdout
      @options = {}
    end

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
