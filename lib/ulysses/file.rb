# frozen_string_literal: true

require "zip"

module Ulysses
  # A `Ulysses::File` represents a file saved to disk by Ulysses with a `.ulyz`
  # extension. This is a zip file containing the text contents in XML format
  # along with all assets.
  class File
    # @param [String, #to_path] path path the file to read.
    def self.open(path)
      file = new(path)
      file.open
      yield file
    ensure
      file.close
    end

    # @param [String, #to_path] path path the file to read.
    def initialize(path)
      @path = Pathname(path)
    end

    # Open the source file for reading.
    #
    # This needs to be called before other operations can be used.
    #
    # @return [Ulysses::File]
    def open
      @zip_file = Zip::File.open(@path.open)
      self
    end

    # Close the source file.
    #
    # @return [Ulysses::File]
    def close
      @zip_file&.close
      self
    end

    # Read the XML contents of the file.
    #
    # @return [String] the XML contents of the file.
    def content
      @zip_file.glob("**/Content.xml").first.get_input_stream.read
    end

    # Get a zip entry for a media file with a particular fingerprint substring
    # in its filename.
    #
    # @param [String] fingerprint
    # @return [Zip::Entry, nil]
    def media(fingerprint)
      @zip_file.glob("**/Media/*#{fingerprint}*").first
    end

    # Extract file `subpath` from the source zip file to a given `dest` on disk.
    #
    # @param [String] subpath
    # @param [String] dest
    # @return [Zip::Entry]
    def extract_to(subpath, dest)
      @zip_file.extract(subpath, dest)
    end
  end
end
