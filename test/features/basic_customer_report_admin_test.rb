require "test_helper"

feature "BasicCustomerReportAdminTest" do
	include ActiveJob::TestHelper

  scenario "Generate" do
  	visit root_path
  	page.find(:link, "Basic Customer Reports").click
  	page.must_have_content "Generate Report"

  	assert_performed_with(job: BasicCustomerReportJob) do
      page.find(:link, "Generate Report").click
      page.must_have_content "Report Generation in progress"
      
      basic_customer_report = BasicCustomerReport.last
      page.must_have_content "Report ##{basic_customer_report.id}"
      page.must_have_content "Completed"
      
      page.find(:link, "Report ##{basic_customer_report.id}").click
      page.response_headers['Content-Type'].must_equal "text/csv"
      page.body.must_match BasicCustomerReport::CSV_COLUMNS.map(&:titleize).join(",")
    end
  end
end
