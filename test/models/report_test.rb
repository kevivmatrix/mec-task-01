require "test_helper"

describe Report do
  let(:report) { Report.new }

  it "must be valid" do
    value(report).must_be :valid?
  end
end
