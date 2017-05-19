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
      # TODO - Figure out the percentage logic here
      total 100
      at 5, "Almost done"
      sleep 30
      @report.generate
      at 50, "Almost done"
      sleep 100
      @report.completed!
    rescue Exception => error
      @report.failed! error.message
    ensure
      # end_tracking!
    end
  end
end
