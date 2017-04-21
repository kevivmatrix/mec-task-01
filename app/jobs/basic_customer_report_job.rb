class BasicCustomerReportJob < ApplicationJob
  queue_as :default

  def perform(*args)
  	basic_customer_report = BasicCustomerReport.create
  	basic_customer_report.generate
  end
end
