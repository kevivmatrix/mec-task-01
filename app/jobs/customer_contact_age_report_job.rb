class CustomerContactAgeReportJob < ApplicationJob
  queue_as :default

  rescue_from Exception do |error|
    @customer_contact_age_report.failed! error.message
  end

  def perform parameters
    @customer_contact_age_report = CustomerContactAgeReport.create(parameters: parameters)
    @customer_contact_age_report.processing!
    @customer_contact_age_report.generate
    @customer_contact_age_report.completed!
  end
end
