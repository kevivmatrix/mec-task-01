require "test_helper"

describe CustomerType do
  let(:customer_type) { FactoryGirl.create :customer_type }

  it "must be valid" do
    value(customer_type).must_be :valid?
  end
end
