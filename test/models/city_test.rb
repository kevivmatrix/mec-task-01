require "test_helper"

describe City do
  let(:city) { City.new }

  it "must be valid" do
    value(city).must_be :valid?
  end
end
