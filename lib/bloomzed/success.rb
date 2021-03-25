require_relative "result"

module Bloomzed
  def self.Success(*value)
    Success.new(value)
  end

  class Success < Result; end
end
