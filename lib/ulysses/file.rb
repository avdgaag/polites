# frozen_string_literal: true

require 'zip'

module Ulysses
  # A `Ulysses::File` represents a file saved to disk by Ulysses with a `.ulyz`
  # extension. This is a zip file containing the text contents in XML format
  # along with all assets.
  class File
    # @param [String, #to_path] path path the file to read.
    def initialize(path)
      @path = Pathname(path)
    end

    # @return [String] the XML contents of the file.
    def content
      Zip::File.open(@path.open) do |zip_file|
        zip_file.glob('**/Content.xml').first.get_input_stream.read
      end
    end
  end
end
