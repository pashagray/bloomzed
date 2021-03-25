# frozen_string_literal: true

RSpec.describe Bloomzed::Payments::Create do
  let(:params) { { host: "http::/79.142.93.158:3333", payment_type: 1, description: "test payment", amount: 10_000 } }

  it "validates params" do
    expect(subject.call({})).to eq Bloomzed::Failure[:missing_params, %i[host payment_type description amount]]
  end

  it "rejects not expected params" do
    expect(subject.call(params.merge(bad_param: 1))).to eq Bloomzed::Failure[:unexpected_params, %i[bad_param]]
  end

  it "validates params" do
    expect(subject.call(params.merge(payment_type: "1", description: 1))).to eq Bloomzed::Failure[:wrong_params_schema, { payment_type: { expected: Integer, actual: String }, description: { expected: String, actual: Integer } }]
  end

  it "obtains payment page" do
    expect(subject.call(params)).to eq Bloomzed::Success(1)
  end
end
