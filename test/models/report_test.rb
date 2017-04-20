require 'test_helper'

class ReportTest < ActiveSupport::TestCase

  test "Status field should be enumerized to correct values" do
    desired_statuses = %w(pending processing complete)
    result = valid_enumerized(:report, :status, Report::VALID_STATUSES, desired_statuses)
    assert result.valid, result.messages.first
  end

end
