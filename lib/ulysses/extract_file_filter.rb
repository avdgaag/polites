require_relative './file'

module Ulysses
  # Nanoc binary filter to extract files from a zip file to a given output file.
  # This allows a single Ulysses file to be linked to multiple Nanoc items,
  # which are extracted when needed during the compilation process.
  class ExtractFileFilter < Nanoc::Filter
    identifier :extract_file
    type :binary

    def run(filename, _params = {})
      File.open(filename) do |f|
        f.extract_to(@item[:subpath], output_filename)
      end
    end
  end
end
