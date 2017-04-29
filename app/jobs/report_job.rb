class ReportJob < ApplicationJob
  queue_as :default

  rescue_from Exception do |error|
    @report.failed! error.message
    raise error
  end

  def perform report
    @report = report
    @report.processing!
    @report.generate
    @report.completed!
  end
end
