# frozen_string_literal: true

RSpec.describe Bloomzed::Payments::Create do
  let(:params) { { host: "http::/79.142.93.158:3333", payment_type: 1, description: "test payment", amount: 10_000 } }

  it "validates params" do
    expect(subject.call({})).to eq Bloomzed::Failure[:missing_params, %i[host payment_type description amount]]
  end

  it "rejects not expected params" do
    expect(subject.call(params.merge(bad_param: 1))).to eq Bloomzed::Failure[:unexpected_params, %i[bad_param]]
  end

  # it "obtains payment page" do
  #   expect(subject.call(params)).to eq Bloomzed::Success[:payments_create, 1]
  # end
end
