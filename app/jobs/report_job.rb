class ReportJob < ApplicationJob
  queue_as :default

  rescue_from Exception do |error|
    @report.failed! error.message
    end_tracking! "failed"
    raise error
  end

  def perform report
    start_tracking! report
    @report = report
    @report.processing!
    @report.generate
    @report.completed!
    end_tracking!
  end
end
