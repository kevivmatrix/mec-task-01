class ReportJob < ApplicationJob

  attr_accessor :report

  queue_as :default

  def perform report
    begin
      @report = report
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
