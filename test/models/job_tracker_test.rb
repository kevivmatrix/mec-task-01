require "test_helper"

class JobTrackerTest < ActiveSupport::TestCase
  
  test "Status field should be enumerized to correct values" do
    desired_statuses = %w(waiting completed failed)
    result = valid_enumerized(:job_tracker, :status, JobTracker::VALID_STATUSES, desired_statuses)
    assert result.valid, result.messages.first
  end

end
