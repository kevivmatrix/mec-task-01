require "test_helper"

feature "CustomerColorReportAdminTest" do
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
    page.find("#report_type option[value='CustomerColorReport']").select_option

    # assert_performed_with(job: ReportJob) do
    Sidekiq::Testing.inline! do
      page.find("input[type='submit']").click
      page.must_have_content "Customer color report was successfully created."

      customer_color_report = CustomerColorReport.last
      page.must_have_content "label1.csv"
      page.must_have_content "Completed"
      page.must_have_content "None"
      
      page.find(:link, "label1.csv").click
      page.response_headers['Content-Type'].must_equal "text/csv"

      csv_data = page.body.split("\n")
      header_column = csv_data[0]
      first_color_column = csv_data[1]
      fourth_color_column = csv_data[4]
      average_column_1 = csv_data[-2]
      average_column_2 = csv_data[-1]

      assert_equal "Color,# Customers favorited,# Customers only favorited", header_column
      assert_equal "black,1,0", first_color_column
      assert_equal "green,2,0", fourth_color_column

      assert_equal "Average # of Colors per Customer,2.0", average_column_1
      assert_equal "Average # of Customers per Color,0.214", average_column_2
    end
  end
end
