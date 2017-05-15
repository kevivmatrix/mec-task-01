require "test_helper"

feature "BasicCustomerReportAdminTest" do
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
    page.find(:css, "#report_type").set("BasicCustomerReport")
    page.find("#report_type option[value='BasicCustomerReport']").select_option

    assert_performed_with(job: ReportJob) do
      page.find("input[type='submit']").click
      page.must_have_content "Basic customer report was successfully created."
      
      basic_customer_report = BasicCustomerReport.last
      page.must_have_content "label1.csv"
      page.must_have_content "Completed"
      page.must_have_content "None"
      
      page.find(:link, "label1.csv").click
      page.response_headers['Content-Type'].must_equal "text/csv"

      csv_data = CSV.parse page.body
      header_column = csv_data[0]
      first_customer_data = csv_data[1]
      last_customer_data = csv_data[-1]

      assert_equal 23, header_column.count
      assert_equal header_column, BasicCustomerReport.csv_columns.values
      assert_equal 4, csv_data.count

      assert_equal "Customer 1", first_customer_data[0]
      assert_equal "customer_1@gmail.com", first_customer_data[1]
      assert_equal "1234", first_customer_data[2]
      assert_equal "male", first_customer_data[3]
      assert_equal "Customer 1 Address", first_customer_data[4]
      assert_equal "New York", first_customer_data[5]
      assert_equal "USA", first_customer_data[6]
      assert_equal "11101", first_customer_data[7]
      assert_equal "21", first_customer_data[8]
      assert_equal "red, orange", first_customer_data[9]
      assert_equal "facebook1", first_customer_data[10]
      assert_equal "twitter1", first_customer_data[11]
      assert_equal "instagram1", first_customer_data[12]
      assert_equal "pinterest1", first_customer_data[13]
      assert_equal "linkedin1", first_customer_data[14]
      assert_equal "reddit1", first_customer_data[15]
      assert_equal "google_plus1", first_customer_data[16]
      assert_equal "skype1", first_customer_data[17]
      assert_equal "slack1", first_customer_data[18]
      assert_equal "landline1", first_customer_data[19]
      assert_equal "mobile1", first_customer_data[20]
      assert_equal customer_1.created_at.to_s, first_customer_data[21]
      assert_equal customer_1.updated_at.to_s, first_customer_data[22]

      assert_equal "Customer 3", last_customer_data[0]
      assert_equal "customer_3@gmail.com", last_customer_data[1]
      assert_equal "7890", last_customer_data[2]
      assert_equal "female", last_customer_data[3]
      assert_equal "Customer 3 Address", last_customer_data[4]
      assert_equal "Washington", last_customer_data[5]
      assert_equal "USA", last_customer_data[6]
      assert_equal "11103", last_customer_data[7]
      assert_equal "43", last_customer_data[8]
      assert_equal "blue, green", last_customer_data[9]
      assert_equal "facebook3", last_customer_data[10]
      assert_equal "twitter3", last_customer_data[11]
      assert_equal "instagram3", last_customer_data[12]
      assert_equal "pinterest3", last_customer_data[13]
      assert_equal "linkedin3", last_customer_data[14]
      assert_equal "reddit3", last_customer_data[15]
      assert_equal "google_plus3", last_customer_data[16]
      assert_equal "skype3", last_customer_data[17]
      assert_equal "slack3", last_customer_data[18]
      assert_equal "landline3", last_customer_data[19]
      assert_equal "mobile3", last_customer_data[20]
      assert_equal customer_3.created_at.to_s, last_customer_data[21]
      assert_equal customer_3.updated_at.to_s, last_customer_data[22]
    end
  end
end
