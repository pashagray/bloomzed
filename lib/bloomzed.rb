# frozen_string_literal: true
require "httparty"

require_relative "bloomzed/version"
require_relative "bloomzed/failure"
require_relative "bloomzed/success"
require_relative "bloomzed/payments/create"

module Bloomzed
  class Error < StandardError; end

  class ApiError < StandardError; end
end
