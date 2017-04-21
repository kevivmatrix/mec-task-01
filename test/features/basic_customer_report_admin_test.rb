require "test_helper"

feature "BasicCustomerReportAdminTest" do
	include ActiveJob::TestHelper

  scenario "Generate" do
  	visit root_path
  	# Test Dropdown
  	page.find(:link, "Basic Customer Reports").click
  	page.must_have_content "Generate Report"
  	page.find(:link, "Generate Report").click
  	page.must_have_content "Report Generation in progress"

  	assert_performed_with(job: BasicCustomerReportJob) do
      page.find(:link, "Generate Report").click
      page.must_have_content "Report Generation in progress"
    end
  end
end
