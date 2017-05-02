require 'test_helper'

class ReportTest < ActiveSupport::TestCase

  test "Status field should be enumerized to correct values" do
    desired_statuses = %w(waiting processing completed failed)
    result = valid_enumerized(:basic_customer_report, :status, Report::VALID_STATUSES, desired_statuses)
    assert result.valid, result.messages.first
  end

  test "Enumerize helper methods" do
    report = FactoryGirl.create :report, type: "BasicCustomerReport"
    assert report.waiting?
    
    report.processing! "Processing"
    assert report.processing?
    assert_equal "Processing", report.status_description
    
    report.completed! "Completed"
    assert report.completed?
    assert_equal "Completed", report.status_description
    
    report.failed! "Failed"
    assert report.failed?
    assert_equal "Failed", report.status_description
    
    report.waiting! "Waiting"
    assert report.waiting?
    assert_equal "Waiting", report.status_description
  end

end
