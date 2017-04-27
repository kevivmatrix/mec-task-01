class CustomerColorReportJob < ApplicationJob
  queue_as :default

  rescue_from Exception do |error|
    @customer_color_report.failed! error.message
  end

  def perform parameters
    @customer_color_report = CustomerColorReport.create(parameters: parameters)
    @customer_color_report.processing!
    @customer_color_report.generate
    @customer_color_report.completed!
  end
end
