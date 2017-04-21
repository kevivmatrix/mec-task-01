class BasicCustomerReportJob < ApplicationJob
  queue_as :default

  def perform(*args)
  	basic_customer_report = BasicCustomerReport.create
  	basic_customer_report.processing!
  	begin
  		basic_customer_report.generate
  	rescue
  		basic_customer_report.failed!
  	else
	  	basic_customer_report.completed!
  	end
  end
end
