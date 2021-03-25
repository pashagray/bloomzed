module Bloomzed
  class Failure
    attr_reader :value

    def self.[](*value)
      new(value)
    end

    def initialize(value)
      @value = value
    end

    def ==(other)
      return false unless other.instance_of?(self.class)

      @value == other.value
    end
  end
end
