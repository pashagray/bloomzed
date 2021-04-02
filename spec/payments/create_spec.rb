# frozen_string_literal: true

RSpec.describe Bloomzed::Payments::Create do
  let(:params) do
    {
      payment_type: 1,
      description: "test payment",
      amount: 10_000,
      currency: "KZT",
      phone_number: "77771234567",
      result_url: "https://google.com/result",
      success_url: "https://google.com/success",
      failure_url: "https://google.com/failure",
      back_url: "https://google.com/back",
      products: [
        {
          id: 1,
          name: "super product",
          amount: 1000,
          count: 1
        }
      ]
    }
  end

  describe "#call" do
    subject { described_class.new(sid: "0201029087", password: "ZEYC3UAW}Q{9&D5") }

    context "with bad credentials" do
      subject { described_class.new(sid: "3506464835", password: "bad_password") }

      it "returns failure" do
        expect(subject.call(params)).to eq Bloomzed::Failure[:wrong_credentials, "Check your SID and password"]
      end
    end

    context "with correct credentials" do
      it "returns failure" do
        expect(subject.call(params).class).to be Bloomzed::Success
        expect(subject.call(params).value).to include("http://79.142.93.158:3000/")
      end
    end
  end
end
