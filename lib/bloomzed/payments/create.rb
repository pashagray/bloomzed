require "securerandom"

module Bloomzed
  module Payments
    # Using call(params) with correct params on intance of this
    # class will return Success({ link: "https://xxx" }) with
    # link to payment gate, where user is able to perform payment.
    class Create
      REQUIRED_PARAMS = {
        payment_type: Integer,
        description: String,
        amount: Integer
      }.freeze

      OPTIONAL_PARAMS = {
        phone_number: String,
        products: Array
      }.freeze

      AVAILABLE_PARAMS = REQUIRED_PARAMS.merge(OPTIONAL_PARAMS).freeze

      def initialize(sid:, password:, endpoint: "http://79.142.93.158:3333")
        @sid = sid
        @password = password
        @endpoint = endpoint
      end

      def call(
        payment_type:,
        amount:,
        description:,
        currency:,
        phone_number:,
        result_url:,
        success_url:,
        failure_url:,
        back_url:
      )
        @payment_type = payment_type
        @amount = amount
        @description = description
        @phone_number = phone_number
        @currency = currency
        @result_url = result_url
        @success_url = success_url
        @failure_url = failure_url
        @back_url = back_url
        @idempotency = SecureRandom.uuid

        request!
      rescue ApiError
        @failure
      end

      private

      def request!
        response = HTTParty.post(
          "#{@endpoint}/payments",
          {
            headers: {
              "Content-Type" => "application/json",
              "X-Idempotency" => @idempotency
            },
            body: json_request_body,
            basic_auth: { username: @sid, password: @password }
          }
        )

        fail!(:wrong_credentials, "Check your SID and password") if response.code == 401

        body = JSON.parse(response.body)

        Bloomzed::Success(body["paymentPageUrl"])
      end

      def fail!(failure_code, payload)
        @failure = Bloomzed::Failure[failure_code, payload]
        raise Bloomzed::ApiError
      end

      def json_request_body
        {
          "paymentType" => @payment_type,
          "phoneNumber" => @phone_number,
          "amount" => {
            "sum" => @amount,
            "currency" => {
              "code" => @currency,
              "minorUnits" => 100
            }
          },
          "description" => @description,
          "options" => {
            "callbacks" => {
              "resultUrl" => @result_url,
              "successUrl" => @success_url,
              "failureUrl" => @failure_url,
              "backUrl" => @back_url
            }
          }
        }.to_json
      end
    end
  end
end
