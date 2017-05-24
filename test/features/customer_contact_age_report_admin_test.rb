require "test_helper"

feature "CustomerContactAgeReportAdminTest" do
  include ActiveJob::TestHelper

  scenario "Generate" do
    customers = setup_customers
    customer_1 = customers[0]
    customer_2 = customers[1]
    customer_3 = customers[2]

    visit root_path
    page.find(:link, "Reports").click
    page.find(:link, "New Report").click
    page.find(:css, "#report_label").set("Label1")
    page.find("#report_type option[value='CustomerContactAgeReport']").select_option

    assert_performed_with(job: ReportJob) do
    # Sidekiq::Testing.inline! do
      page.find("input[type='submit']").click
      page.must_have_content "Customer contact age report was successfully created."

      customer_color_report = CustomerContactAgeReport.last
      page.must_have_content "label1.csv"
      page.must_have_content "Completed"
      page.must_have_content "None"
      
      page.find(:link, "label1.csv").click
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
