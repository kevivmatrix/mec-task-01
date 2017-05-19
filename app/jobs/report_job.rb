class ReportJob < ApplicationJob

  attr_accessor :report

  include ActiveJobStatus::Hooks

  queue_as :default

  def perform report
    begin
      @report = report
      job_status = ActiveJobStatus.fetch(job_id)
      start_tracking!
      @report.processing!
      # TODO - Figure out the percentage logic here
      @report.generate
      @report.completed!
    rescue Exception => error
      @report.failed! error.message
    ensure
      end_tracking!
    end
  end
end
