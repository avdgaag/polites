module Ulysses
  class Tag
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def eql?(other)
      other.is_a?(self.class) && name == other.name
    end
    alias == eql?
  end
end
