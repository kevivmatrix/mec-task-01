# class ReportJob < ApplicationJob # Tracking percent complete doesn't work with ActiveJob
class ReportJob
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  attr_accessor :report

  # queue_as :default

  def perform report_id
    begin
      @report = Report.find report_id
      # start_tracking!
      @report.processing!
      @report.generate({ background_job: self })
      @report.completed!
    rescue Exception => error
      @report.failed! error.message
    ensure
      # end_tracking!
      at 100
    end
  end
end
