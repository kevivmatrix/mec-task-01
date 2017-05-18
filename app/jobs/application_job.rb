class ApplicationJob < ActiveJob::Base

  attr_accessor :tracker

  def start_tracking! trackable
    @tracker = JobTracker.create trackable: trackable
  end

  def track percent
    tracker.update percent: percent
  end

  def end_tracking! status="completed"
    tracker.update(
      percent: 100,
      status: status
    )
  end

end
