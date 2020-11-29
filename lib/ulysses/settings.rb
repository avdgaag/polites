require_relative './plist'

module Ulysses
  class Settings
    # Read all combined .plist files in a directory into a single data
    # structure.
    #
    # @param [#to_s, #to_path] path root directory to look up .plist files in.
    # @return [Ulysses::Settings]
    def self.from_directory(path)
      Pathname(path)
        .glob('.*.plist')
        .inject({}) { |s, f| s.merge Plist.new(f).to_h }
        .then { |s| new(s) }
    end

    # @param [Hash] settings
    def initialize(settings = {})
      @settings = settings.to_h
      freeze
    end

    # Look up a setting by key.
    #
    # @param [String] key
    # @return [Object]
    def [](key)
      @settings[key]
    end
  end
end
