require 'test_helper'

class ReportTest < ActiveSupport::TestCase

  test "Status field should be enumerized to correct values" do
    desired_statuses = %w(waiting processing completed failed)
    result = valid_enumerized(:report, :status, Report::VALID_STATUSES, desired_statuses)
    assert result.valid, result.messages.first
  end

  test "Enumerize helper methods" do
    report = FactoryGirl.create :report
    assert report.waiting?
    
    report.processing! "Processing"
    assert report.processing?
    assert_equal report.status_description, "Processing"
    
    report.completed! "Completed"
    assert report.completed?
    assert_equal report.status_description, "Completed"
    
    report.failed! "Failed"
    assert report.failed?
    assert_equal report.status_description, "Failed"
    
    report.waiting! "Waiting"
    assert report.waiting?
    assert_equal report.status_description, "Waiting"
  end

end
