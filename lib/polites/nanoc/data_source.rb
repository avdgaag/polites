# frozen_string_literal: true

require 'pathname'
require 'polites/settings'
require 'polites/parser'
require 'polites/file'
require 'polites/html_formatter'

module Polites
  module Nanoc
    # A data source for Nanoc that creates Nanoc content items from Polites files
    # in a particular directory.
    class DataSource < ::Nanoc::DataSource
      identifier :polites

      def up
        @root = Pathname(@config[:path])
        @settings = Settings.from_directory(@root)
        @extension = ".#{@settings['defaultPathExtensions']}"
        @input_files = @root.glob("*#{@extension}")
        @parser = Polites::Parser.new
        @formatter = Polites::HtmlFormatter.new
      end

      def items
        @input_files.flat_map do |input_file|
          File.open(input_file) do |file|
            sheet = @parser.parse_sheet(file.content)

            inline_file_items = sheet.inline_files.map do |image|
              build_file_item(file.media(image.image), image.image, input_file, image.filename)
            end

            file_items = sheet.attached_files.map do |id|
              build_file_item(file.media(id), id, input_file)
            end

            [
              new_item(
                @formatter.call(sheet),
                {
                  keywords: sheet.keywords,
                  image: sheet.attached_files.first,
                  image_caption: sheet.notes.any? ? @formatter.call(sheet.notes.first) : nil,
                  inline_file_items: inline_file_items,
                  filename: input_file.to_s,
                  mtime: input_file.mtime
                },
                identifier(input_file)
              ),
              *inline_file_items,
              *file_items
            ]
          end
        end
      end

      private

      def build_file_item(entry, id, input_file, filename = nil)
        p = filename ? Pathname(filename) : Pathname(entry.name).basename
        i = "#{identifier(input_file)}/media#{identifier(p, p.extname)}"
        new_item(
          input_file.expand_path.to_s,
          {
            explicit_filename: filename,
            id: id,
            subpath: entry.name,
            mtime: input_file.mtime
          },
          i,
          binary: true
        )
      end

      def identifier(path, extension = @extension)
        "/#{path
          .relative_path_from(@root)
          .basename(extension)
          .to_s
          .then { |s| underscore(s) }}#{extension}"
      end

      def underscore(str)
        str
          .gsub(/[^a-zA-Z0-9\-_]/, '-')
          .squeeze('-')
          .gsub(/^-*|-*$/, '')
          .downcase
      end
    end
  end
end
