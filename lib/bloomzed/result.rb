module Bloomzed
  class Result
    attr_reader :value

    def self.[](*value)
      new(value)
    end

    def initialize(value)
      @value = value.size > 1 ? value : value.first
    end

    def ==(other)
      return false unless other.instance_of?(self.class)

      @value == other.value
    end
  end
end
