require "test_helper"

feature "BasicCustomerReportAdminTest" do
	include ActiveJob::TestHelper

  scenario "Generate" do
    customer_1 = FactoryGirl.create(:customer, 
      favorite_colors: ["red", "orange"], zip_code: "11101", age: 21,
      name: "Customer 1", email: "customer_1@gmail.com", phone: "1234", gender: "male",
      address: "Customer 1 Address", city: "New York", country: "USA",
      contacts: { 
        facebook: "facebook1", twitter: "twitter1", instagram: "instagram1",
        pinterest: "pinterest1", linkedin: "linkedin1", reddit: "reddit1", 
        google_plus: "google_plus1", skype: "skype1", slack: "slack1",
        landline: "landline1", mobile: "mobile1"
      }
    )
    customer_2 = FactoryGirl.create(:customer, 
      favorite_colors: ["yellow", "green"], zip_code: "11102", age: 32,
      name: "Customer 2", email: "customer_2@gmail.com", phone: "4567", gender: "male",
      address: "Customer 2 Address", city: "California", country: "USA",
      contacts: { 
        facebook: "facebook2", twitter: "twitter2", instagram: "instagram2",
        pinterest: "pinterest2", linkedin: "linkedin2", reddit: "reddit2", 
        google_plus: "google_plus2", skype: "skype2", slack: "slack2",
        landline: "landline2", mobile: "mobile2"
      }
    )
    customer_3 = FactoryGirl.create(:customer, 
      favorite_colors: ["blue", "green"], zip_code: "11103", age: 43,
      name: "Customer 3", email: "customer_3@gmail.com", phone: "7890", gender: "female",
      address: "Customer 3 Address", city: "Washington", country: "USA",
      contacts: { 
        facebook: "facebook3", twitter: "twitter3", instagram: "instagram3",
        pinterest: "pinterest3", linkedin: "linkedin3", reddit: "reddit3", 
        google_plus: "google_plus3", skype: "skype3", slack: "slack3",
        landline: "landline3", mobile: "mobile3"
      }
    )

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

      csv_data = CSV.parse page.body
      header_column = csv_data[0]
      first_customer_data = csv_data[1]
      last_customer_data = csv_data[-1]

      assert_equal 23, header_column.count
      assert_equal header_column, BasicCustomerReport::CSV_COLUMNS.map(&:titleize)
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
