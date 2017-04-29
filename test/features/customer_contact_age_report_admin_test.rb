require "test_helper"

feature "CustomerContactAgeReportAdminTest" do
  include ActiveJob::TestHelper

  scenario "Generate" do
    customers = setup_customers
    customer_1 = customers[0]
    customer_2 = customers[1]
    customer_3 = customers[2]

    visit root_path
    page.find(:link, "Customer Contact Age Reports").click
    page.must_have_content "Generate Report"

    assert_performed_with(job: ReportJob) do
      page.find(:link, "Generate Report").click
      page.must_have_content "Customer Contact Age Report Generation in progress"

      customer_color_report = CustomerContactAgeReport.last
      page.must_have_content "Customer Contact-Age Report ##{customer_color_report.id}"
      page.must_have_content "Completed"
      
      page.find(:link, "Customer Contact-Age Report ##{customer_color_report.id}").click
      page.response_headers['Content-Type'].must_equal "text/csv"

      csv_data = page.body.split("\n")
      header_column = csv_data[0]
      first_contact_column = csv_data[1]
      last_contact_column = csv_data[-1]

      assert_equal "Contact Type,# Customers,Min. Age,Max. Age,Avg. Age", header_column
      assert_equal "facebook,3,21,43,32.0", first_contact_column
      assert_equal "mobile,3,21,43,32.0", last_contact_column
    end
  end
end
