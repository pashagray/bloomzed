module Bloomzed
  module Payments
    # Using call(params) with correct params on intance of this
    # class will return Success({ link: "https://xxx" }) with
    # link to payment gate, where user is able to perform payment.
    class Create
      REQUIRED_PARAMS = {
        host: String,
        payment_type: Integer,
        description: String,
        amount: Integer
      }.freeze

      OPTIONAL_PARAMS = {
        phone_number: String,
        products: Array
      }.freeze

      AVAILABLE_PARAMS = REQUIRED_PARAMS.merge(OPTIONAL_PARAMS).freeze

      def call(params = {})
        @params = params

        # Step-by-step checks
        # Prevent chain execution if any of step fails
        check_missing_params!
        check_unexpected_params!
        validate_params!

        # If we are here, all checks passed and
        # we are ready to make request to API
        request!

      # Prevent program to raise error and return
      # Bloomzed::Failure with all error information instead
      rescue Bloomzed::Error
        @failure
      end

      def check_missing_params!
        missing_params = REQUIRED_PARAMS.keys - @params.keys
        fail!(:missing_params, missing_params) if missing_params.any?
      end

      def check_unexpected_params!
        unexpected_params = @params.keys - AVAILABLE_PARAMS.keys
        fail!(:unexpected_params, unexpected_params) if unexpected_params.any?
      end

      def validate_params!
        types_mismatch = {}
        @params.each do |param|
          actual = param[1].class
          expected = AVAILABLE_PARAMS[param[0]]
          types_mismatch[param[0]] = { expected: expected, actual: actual } unless param[1].instance_of?(expected)
        end
        fail!(:wrong_params_schema, types_mismatch) if types_mismatch.any?
      end

      def request!
       # Request to API
      end

      def fail!(error_code, payload)
        @failure = Bloomzed::Failure[error_code, payload]
        raise Bloomzed::Error, [error_code, payload]
      end
    end
  end
end
