require "open3"
require "json"

module Ulysses
  # Read macos binary .plist files into a Hash by converting them to JSON format
  # using the macos native `plutil` program. This only works on macos.
  class Plist
    # @param [#to_s] path
    def initialize(path)
      @path = path
    end

    # @return [Hash]
    def to_h
      @content ||= read_plist
    end

    private

    def read_plist
      "plutil -convert json -o - #{@path}"
        .then { |s| Open3.capture2(s) }
        .then { |(json, _)| JSON.parse(json) }
    end
  end
end
