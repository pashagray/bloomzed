module Bloomzed
  module Payments
    class Create
      REQUIRED_PARAMS = %i[
        host
        payment_type
        description
        amount
      ].freeze

      OPTIONAL_PARAMS = %i[
        phone_number
      ].freeze

      def call(params = {})
        @params = params
        check_missing_params!
        check_unexpected_params!
        request!
      rescue Bloomzed::Error
        @failure
      end

      def check_missing_params!
        missing_params = REQUIRED_PARAMS - @params.keys
        fail!(:missing_params, missing_params) if missing_params.any?
      end

      def check_unexpected_params!
        unexpected_params = @params.keys - (REQUIRED_PARAMS + OPTIONAL_PARAMS)
        fail!(:unexpected_params, unexpected_params) if unexpected_params.any?
      end

      def request!
        # make request to Bloomzed server
      end

      def fail!(error_code, payload)
        @failure = Bloomzed::Failure[error_code, payload]
        raise Bloomzed::Error, [error_code, payload]
      end
    end
  end
end
