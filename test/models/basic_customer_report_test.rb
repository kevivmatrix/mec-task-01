require "test_helper"

class BasicCustomerReportTest < ActiveSupport::TestCase

  test "Enumerize helper methods" do
    basic_customer_report = FactoryGirl.create :basic_customer_report
    assert basic_customer_report.pending?
    basic_customer_report.processing!
    assert basic_customer_report.processing?
    basic_customer_report.completed!
    assert basic_customer_report.complete?
    basic_customer_report.pending!
    assert basic_customer_report.pending?
  end

end
