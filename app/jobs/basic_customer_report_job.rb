class BasicCustomerReportJob < ApplicationJob
  queue_as :default

  rescue_from Exception do |error|
    @basic_customer_report.failed! error.message
  end

  def perform parameters
  	@basic_customer_report = BasicCustomerReport.create(parameters: parameters)
  	@basic_customer_report.processing!
		@basic_customer_report.generate
  	@basic_customer_report.completed!
  end
end
