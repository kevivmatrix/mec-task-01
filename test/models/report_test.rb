require 'test_helper'

class ReportTest < ActiveSupport::TestCase

  test "Status field should be enumerized to correct values" do
    desired_statuses = %w(pending processing completed failed)
    result = valid_enumerized(:report, :status, Report::VALID_STATUSES, desired_statuses)
    assert result.valid, result.messages.first
  end

  test "Enumerize helper methods" do
    report = FactoryGirl.create :report
    assert report.pending?
    report.processing!
    assert report.processing?
    report.completed!
    assert report.completed?
    report.failed!
    assert report.failed?
    report.pending!
    assert report.pending?
  end

end
