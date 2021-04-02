require_relative "result"

module Bloomzed
  def self.Failure(*value)
    Failure.new(value)
  end

  class Failure < Result
    def success?
      false
    end
  end
end
